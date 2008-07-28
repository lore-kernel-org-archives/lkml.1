Return-Path: <linux-kernel-owner+w=401wt.eu-S1753879AbYG1IKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879AbYG1IKl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 04:10:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750736AbYG1IKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 04:10:32 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:53731 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbYG1IKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 04:10:31 -0400
X-Auth-Info: 07jqgDS/lRnWQjJfa31prvi9DxR2p9C0Ves0eZdDndE=
X-Auth-Info: 07jqgDS/lRnWQjJfa31prvi9DxR2p9C0Ves0eZdDndE=
X-Auth-Info: 07jqgDS/lRnWQjJfa31prvi9DxR2p9C0Ves0eZdDndE=
X-Auth-Info: 07jqgDS/lRnWQjJfa31prvi9DxR2p9C0Ves0eZdDndE=
X-Auth-Info: 07jqgDS/lRnWQjJfa31prvi9DxR2p9C0Ves0eZdDndE=
X-Auth-Info: 07jqgDS/lRnWQjJfa31prvi9DxR2p9C0Ves0eZdDndE=
X-Auth-Info: 07jqgDS/lRnWQjJfa31prvi9DxR2p9C0Ves0eZdDndE=
X-Auth-Info: 07jqgDS/lRnWQjJfa31prvi9DxR2p9C0Ves0eZdDndE=
X-Auth-Info: 07jqgDS/lRnWQjJfa31prvi9DxR2p9C0Ves0eZdDndE=
Message-ID: <488D7F5D.8090400@grandegger.com>
Date: Mon, 28 Jul 2008 10:12:13 +0200
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Clark Williams <williams@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Luotao Fu <l.fu@pengutronix.de>
Subject: Re: 2.6.24.7-rt16
References: <alpine.LFD.1.10.0807252141420.574@apollo.tec.linutronix.de> <alpine.LFD.1.10.0807271719130.574@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.10.0807271719130.574@apollo.tec.linutronix.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

Thomas Gleixner wrote:
> We are pleased to announce the 2.6.24.7-rt16 tree, which can be
> downloaded from the location:
>  
>   http://rt.et.redhat.com/download/
> 
> Information on the RT patch can be found at:
> 
>   http://rt.wiki.kernel.org/index.php/Main_Page
> 
> This is a bugfix update:
> 
>      - remove m68knommu merge artifacts (tglx)
> 
>      - fix x86_64 UP build (Peter Zijlstra)
> 
>      - powerpc ftrace backport (tglx)

Backport? It's not yet available for 2.6.25.

>      - fix long standing NFS missing preemption check (tglx)
> 
>        This is not a MPC5200 specific problem, it affects all
>        architectures, but was not noticed for a long time as the race
>        window is extremly tight.

This fix finally solves my latency issues with the MPC5200, also with 
2.6.25.8-rt7. After 2 hours the latency is still below 150us for both 
versions. Thanks a lot for your effort.

Wolfgang.


