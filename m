Return-Path: <linux-kernel-owner+w=401wt.eu-S933047AbZGPSwu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933047AbZGPSwu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 14:52:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932952AbZGPSwu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 14:52:50 -0400
Received: from aun.it.uu.se ([130.238.12.36]:65457 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932891AbZGPSwt (ORCPT <rfc822;linux-kernel@Vger.kernel.org>);
	Thu, 16 Jul 2009 14:52:49 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19039.30453.46908.809890@pilspetsen.it.uu.se>
Date: Thu, 16 Jul 2009 20:52:37 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: PTY bug in 2.6.31-rc3?
In-Reply-To: <E1MRTib-0002Cw-T0@closure.thunk.org>
References: <E1MRTib-0002Cw-T0@closure.thunk.org>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Ts'o writes:
 > Hey Alan,
 > 
 > I'm running 2.6.31-rc3, and twice now over about 36 hours all
 > pseudo-tty's have stopped working on my system.   Everything else works;
 > I can fire up gui applications, but starting any new programs that use
 > pty's will hang.   The only fix seems to be to reboot the system.
 > 
 > I think I remember seeing a similar report, but I thought you said it
 > had been fixed in -rc3 --- does this ring a bell?

That exact same thing happended to me yesterday. The machine had been
running -rc3 for a couple of hours when console and all ptys hung. It
answered pings and accepted remote logins, but they hung immediately.
C-A-D initiated a reboot but hung.

Saw nothing interesting in the logs after the hard reboot.

/Mikael
