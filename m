Return-Path: <linux-kernel-owner+w=401wt.eu-S1759754AbXKBXXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759754AbXKBXXo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 19:23:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753989AbXKBXXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 19:23:35 -0400
Received: from ioctl.codeblau.de ([80.190.240.67]:35710 "EHLO codeblau.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753376AbXKBXXe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 19:23:34 -0400
Date: Sat, 3 Nov 2007 00:23:32 +0100
From: Felix von Leitner <felix-linuxkernel@fefe.de>
To: Rick Jones <rick.jones2@hp.com>
Cc: Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org,
       Netdev <netdev@vger.kernel.org>
Subject: Re: bizarre network timing problem
Message-ID: <20071102232332.GA5739@codeblau.de>
References: <20071017205127.GA21334@codeblau.de> <47167BDE.4000103@redhat.com> <20071017220019.GA22765@codeblau.de> <471689BF.2040909@hp.com> <20071018094230.GA2978@codeblau.de> <4717964A.8080100@hp.com> <20071102221146.GA4354@codeblau.de> <472BA5BC.6000901@hp.com> <20071102223856.GA5121@codeblau.de> <472BAB90.8020306@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <472BAB90.8020306@hp.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thus spake Rick Jones (rick.jones2@hp.com):
> Past performance is no guarantee of current correctness :)  And over an 
> Ethernet, there will be a very different set of both timings and TCP 
> segment sizes compared to loopback.

> My guess is that you will find setting the lo mtu to 1500 a very 
> interesting experiment.

Setting the MTU on lo to 1500 eliminates the problem and gives me double
digit MB/sec throughput.

Felix
