Return-Path: <linux-kernel-owner+w=401wt.eu-S1752023AbZG3Qxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023AbZG3Qxh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 12:53:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751953AbZG3Qxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 12:53:36 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:22494 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616AbZG3Qxd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 12:53:33 -0400
X-Greylist: delayed 902 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Jul 2009 12:53:33 EDT
X-SpamScore: -27
X-BigFish: VPS-27(zz542N1432R98dN9371Pzz1202hzzz32i203h6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KNLSVV-01-5PH-02
X-M-MSG: 
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Warning during suspend with MS-7310 mainboard
Date: Thu, 30 Jul 2009 11:38:22 -0500
Message-ID: <6453C3CB8E2B3646B0D020C11261327303620A01@sausexmb4.amd.com>
In-Reply-To: <20090730154734.GB2593@redhat.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Warning during suspend with MS-7310 mainboard
thread-index: AcoRLSphuqJByNxOR2CpaJZC/VWQ6gABuocQ
References: <1248936650.3313.6.camel@queen> <1248949671.3313.10.camel@queen> <20090730154734.GB2593@redhat.com>
From: "Langsdorf, Mark" <mark.langsdorf@amd.com>
To: "Dave Jones" <davej@redhat.com>,
       "Eric Sesterhenn" <eric.sesterhenn@lsexperts.de>
CC: <linux-kernel@vger.kernel.org>, <cpufreq@vger.kernel.org>,
       <rusty@rustcorp.com.au>
X-OriginalArrivalTime: 30 Jul 2009 16:38:22.0828 (UTC) FILETIME=[2744EAC0:01CA1134]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'll look into it.

First time I've had this bug reported, though.

-Mark Langsdorf
Operating System Research Center
AMD 

> -----Original Message-----
> From: Dave Jones [mailto:davej@redhat.com] 
> Sent: Thursday, July 30, 2009 10:48 AM
> To: Eric Sesterhenn
> Cc: linux-kernel@vger.kernel.org; cpufreq@vger.kernel.org; 
> rusty@rustcorp.com.au; Langsdorf, Mark
> Subject: Re: Warning during suspend with MS-7310 mainboard
> 
> On Thu, Jul 30, 2009 at 12:27:51PM +0200, Eric Sesterhenn wrote:
>  > hi,
>  > 
>  > bisecting was faster than expected, reverting the commit 
> removes the warning
>  > http://patchwork.kernel.org/patch/29746/
> 
> I'm just going to #ifdef __powerpc__ the suspend/resume paths 
> of cpufreq
> today, because I'm tired of seeing reports of this bug.
> 
> 	Dave
> 
> 
> 

