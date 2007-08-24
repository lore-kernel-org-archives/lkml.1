Return-Path: <linux-kernel-owner+w=401wt.eu-S1760525AbXHXRJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760525AbXHXRJg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 13:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753372AbXHXRJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 13:09:26 -0400
Received: from palrel10.hp.com ([156.153.255.245]:37595 "EHLO palrel10.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751219AbXHXRJZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 13:09:25 -0400
Message-ID: <46CF1069.7090406@hp.com>
Date: Fri, 24 Aug 2007 10:07:53 -0700
From: Rick Jones <rick.jones2@hp.com>
User-Agent: Mozilla/5.0 (X11; U; HP-UX 9000/785; en-US; rv:1.7.13) Gecko/20060601
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Linas Vepstas <linas@austin.ibm.com>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       Jan-Bernd Themann <ossthema@de.ibm.com>,
       Thomas Klein <tklein@de.ibm.com>, Marcus@ozlabs.org,
       Jan-Bernd Themann <themann@de.ibm.com>, netdev <netdev@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Christoph Raisch <raisch@de.ibm.com>,
       linux-ppc <linuxppc-dev@ozlabs.org>, akepner@sgi.com,
       Eder <meder@de.ibm.com>, Stefan Roscher <stefan.roscher@de.ibm.com>
Subject: Re: RFC: issues concerning the next NAPI interface
References: <200708241559.17055.ossthema@de.ibm.com>	<20070824153703.GN5592@sgi.com>	<200708241747.16592.ossthema@de.ibm.com>	<20070824085203.42f4305c@freepuppy.rosehill.hemminger.net> <20070824165110.GH4282@austin.ibm.com>
In-Reply-To: <20070824165110.GH4282@austin.ibm.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Just to be clear, in the previous email I posted on this thread, I
> described a worst-case network ping-pong test case (send a packet, wait
> for reply), and found out that a deffered interrupt scheme just damaged
> the performance of the test case.  Since the folks who came up with the
> test case were adamant, I turned off the defferred interrupts.  
> While defferred interrupts are an "obvious" solution, I decided that 
> they weren't a good solution. (And I have no other solution to offer).

Sounds exactly like the default netperf TCP_RR test and any number of other 
benchmarks.  The "send  a request, wait for reply, send next request, etc etc 
etc" is a rather common application behaviour afterall.

rick jones
