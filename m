Return-Path: <linux-kernel-owner+w=401wt.eu-S1756191AbXKFVM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756191AbXKFVM0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 16:12:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754337AbXKFVMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 16:12:17 -0500
Received: from palrel11.hp.com ([156.153.255.246]:35976 "EHLO palrel11.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754184AbXKFVMQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 16:12:16 -0500
Message-ID: <4730D8AD.5060401@hp.com>
Date: Tue, 06 Nov 2007 13:12:13 -0800
From: Rick Jones <rick.jones2@hp.com>
User-Agent: Mozilla/5.0 (X11; U; HP-UX 9000/785; en-US; rv:1.7.13) Gecko/20060601
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Felix von Leitner <felix-linuxkernel@fefe.de>
Cc: Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org,
       Netdev <netdev@vger.kernel.org>
Subject: Re: bizarre network timing problem
References: <20071017205127.GA21334@codeblau.de> <47167BDE.4000103@redhat.com>	<20071017220019.GA22765@codeblau.de> <471689BF.2040909@hp.com>	<20071018094230.GA2978@codeblau.de> <4717964A.8080100@hp.com>	<20071102221146.GA4354@codeblau.de> <472BA5BC.6000901@hp.com>	<20071102223856.GA5121@codeblau.de> <472BAB90.8020306@hp.com> <20071102232332.GA5739@codeblau.de>
In-Reply-To: <20071102232332.GA5739@codeblau.de>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Felix von Leitner wrote:
> Thus spake Rick Jones (rick.jones2@hp.com):
> 
>>Past performance is no guarantee of current correctness :)  And over an 
>>Ethernet, there will be a very different set of both timings and TCP 
>>segment sizes compared to loopback.
> 
>>My guess is that you will find setting the lo mtu to 1500 a very 
>>interesting experiment.
> 
> Setting the MTU on lo to 1500 eliminates the problem and gives me double
> digit MB/sec throughput.

I'm not in a position at the moment to test it as my IPoIB systems are offline, 
and not sure you are either, but I will note that with IPoIB bits circa OFED1.2 
the default MTU for IPoIB goes up to 65520 bytes.  If indeed the problem you 
were seeing was related to sub-mss sends and window probing and such, it might 
appear on IPoIB in addition to loopback.

rick jones
