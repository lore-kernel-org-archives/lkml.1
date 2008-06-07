Return-Path: <linux-kernel-owner+w=401wt.eu-S1758633AbYFGWZI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758633AbYFGWZI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 18:25:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753896AbYFGWY4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 18:24:56 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:57111 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753715AbYFGWYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 18:24:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=qqCa7L9wViF35D+7H5kbd/UwqWCWOOiI5CX/SmXwnidq/Fk5yLWdo/LvJfoKLcuJ2e
         KOU+57l0qCH5P2DiKmnQ/Diup8Fm//Wf+llECR9ub7QtQIMTgb/Rmvj421qExXu5h6bK
         2HXoTU2oxydjBjiSetcgvg94UTepgnwFFBjU0=
Message-ID: <19f34abd0806071524p41721005mbe588922ea21d4cc@mail.gmail.com>
Date: Sun, 8 Jun 2008 00:24:54 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Christian Casteyde" <casteyde.christian@free.fr>
Subject: Re: [Bug #10860] total system freeze at boot with 2.6.26-rc
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <dCRO4tbfLzK.A.EiC.c2vSIB@albercik>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <GIilET9wkhI.A.JzB.81vSIB@albercik>
	 <dCRO4tbfLzK.A.EiC.c2vSIB@albercik>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 7, 2008 at 10:42 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.25.  Please verify if it still should be listed.
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=10860
> Subject         : total system freeze at boot with 2.6.26-rc
> Submitter       : Christian Casteyde <casteyde.christian@free.fr>
> Date            : 2008-06-05 12:38 (3 days old)

I looked at the bugzilla entry, but it said not to post any replies in
there. I hope it's okay to reply here, because I couldn't find the
original discussion on LKML.

Christian, did you try the nmi watchdog parameter on boot? It is
really quite simple -- add nmi_watchdog=1 to the kernel parameters.
When the machine freezes, leave it for a minute or two in that state.
The NMI watchdog code might be able to give us a backtrace and tell us
exactly where the machine is hanging. While waiting, you can prepare
the camera... ;-)

(BTW, why isn't this nmi watchdog trick the "standard" reply to hung
kernels? It seems that very few are actually aware of it, or using it
to debug these cases.)

Anyway, good luck with that! :-)


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
