Return-Path: <linux-kernel-owner+w=401wt.eu-S1763472AbXLTNl4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763472AbXLTNl4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 08:41:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763030AbXLTNkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 08:40:13 -0500
Received: from hs-out-0708.google.com ([64.233.178.245]:13157 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763515AbXLTNkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 08:40:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=EbXUfS4apk+bf2EVZKRjAt3jxkSYqULZXCZmDh1Bdxr0vu5z08sYs/eTQkbPj5HTGLsjiwc0kDJnWgc5M1Dgg1khyGsXQl74c/K6LfSd9MRf4M+9vqPqfpzvjQuDQGiiqZX3RJy6fjo0Pt89UNbRhLKZlv0DE6HC2FTCl6rh9uY=
Message-ID: <1985e0f60712200540m1e499a77qaaff18d832c4b8f0@mail.gmail.com>
Date: Thu, 20 Dec 2007 19:10:08 +0530
From: "Jaswinder Singh" <jaswinderlinuxrt@gmail.com>
To: "Juergen Beisert" <jbe@pengutronix.de>
Subject: Re: [patch 3/3] Enable setting of IRQ-thread priorities from kernel cmdline. (repost:CC to LKML)
Cc: linux-rt-users@vger.kernel.org, "Remy Bohmer" <linux@bohmer.net>,
       "Steven Rostedt" <rostedt@goodmis.org>,
       "Arnaldo Carvalho de Melo" <acme@ghostprotocols.net>,
       "Ingo Molnar" <mingo@elte.hu>, "Darren Hart" <dvhltc@us.ibm.com>,
       "Sven-Thorsten Dietrich" <sdietrich@novell.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200712201418.17378.jbe@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071219194551.315868746@bohmer.net>
	 <3efb10970712200425x4b0ffadcpd2ffa3223eda7b3d@mail.gmail.com>
	 <1985e0f60712200445o4f854cdep6eebf1726737229b@mail.gmail.com>
	 <200712201418.17378.jbe@pengutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hello Juergen,

On 12/20/07, Juergen Beisert <jbe@pengutronix.de> wrote:
> On Thursday 20 December 2007 13:45, Jaswinder Singh wrote:
> > So I am curious, if possible, user can switch softirq-threads or IRQs
> > RT tasks to non-RT tasks for slow hardware or least important hardware
> > for NON-RT tasks. So this will improve RT behaviour.
>                     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> Why?
>
> IMHO: Simply decrease the RT priority of less important IRQs or increase all
> other more important IRQs. IRQs are always more important than other
> processes in a system, also in non RT systems.
>

In RT Kernel we have :-
RT Tasks and Non-RT tasks.

So we can also support :-
RT softirq-threads/IRQs and non-RT softirq-threads/IRQs

So RT softirq-threads/IRQs for RT Tasks
and non-RT softirq-threads/IRQs for non-RT Tasks.

OR also remove Non-RT tasks from RT Kernel and simply decrease the RT
priority of less important task as per your suggestions.

Thank you,

Jaswinder Singh.

> Juergen
> --
> Dipl.-Ing. Juergen Beisert | http://www.pengutronix.de
>  Pengutronix - Linux Solutions for Science and Industry
>     Handelsregister: Amtsgericht Hildesheim, HRA 2686
>          Vertretung Sued/Muenchen, Germany
>    Phone: +49-8766-939 228 |  Fax: +49-5121-206917-9
>
