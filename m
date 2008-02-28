Return-Path: <linux-kernel-owner+w=401wt.eu-S1761190AbYB1Smr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761190AbYB1Smr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 13:42:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753776AbYB1Smk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 13:42:40 -0500
Received: from wx-out-0506.google.com ([66.249.82.235]:35993 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699AbYB1Smj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 13:42:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version:content-type:content-disposition:user-agent;
        b=at0CQFJi02y0OpAR2oj2i+Qdnb5ppGcD5WJSxtkBLtV9AuFsoQPeZ2KQQ0/6jEYB6G54VpYOkVnXM1twAW3yzTHWhNud3XvvsIyBg/BR3EVpv/MiC40UkcCbxO+IEymUQOMM8Uwnik0GvN/hv0FknozaFmZUCKyEV7lGOKT+7/s=
Date: Thu, 28 Feb 2008 15:44:07 -0300
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org
Subject: Interactivity issue in 2.6.25-rc3
Message-ID: <20080228184407.GA7117@localhost.ift.unesp.br>
Mail-Followup-To: mingo@elte.hu, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I want to report a bad interactivity which happened in my 
desktop running the latest kernel (2.6.25-rc3-00081-g7704a8b).

I tried to play 'flightgear' and the desktop became _very_
slow while flightgear was "loading scenery objects" (a task
which never finished and I could not play it).

The desktop is a P4 @ 3.0 GHz, 512MB, with the nv graphics 
driver. 

I ran 'fgfs' firstly as a regular user (mafra) and tried to execute
Ingo's cfs-debug script as root in a terminal (mrxvt) which had 3 open
tabs. It took minutes to switch tabs and run cfs-debug-info.sh, which
completed its job only after I managed to kill flightgear (after more
than a couple minutes). The result is here:

http://www.ift.unesp.br/users/crmafra/cfs-debug-info-2008.02.28-14.04.59

[ I want to emphasize that I started the script while the system
was slow, waited a few minutes, killed flightgear, and then
the script finished its job. ]

As I have the group scheduler enabled, I tried to run flightgear as
root to see what happens. I could not even start to run the debug
script, because each letter I typed took many seconds to appear.

The mouse pointer however was responsive, but Window Maker wasn't.
I tried to switch desktops, and after a few minutes the pressing
of "Alt+5" took effect and the desktop 5 appeared ok in the screen.

Then I tried to go back to desktop 1 with "Alt+1" and after exactly
12 minutes I gave up and hit "Ctrl-Alt-Backspace". After 5 or
10 seconds X was killed and everything was normal 
again (no need to reboot).

Is this experience normal? I know that trying to play a game without
3D is a crazy thing, but it didn't feel _fair_ to wait minutes to
see the result of a key press.

