Return-Path: <linux-kernel-owner+w=401wt.eu-S1751648AbXA0QI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751648AbXA0QI3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 11:08:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751747AbXA0QI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 11:08:29 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:35537 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634AbXA0QI2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 11:08:28 -0500
Date: Sat, 27 Jan 2007 17:06:57 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Pierre Ossman <drzeus-list@drzeus.cx>
cc: vandrove@vc.cvut.cz, LKML <linux-kernel@vger.kernel.org>
Subject: Re: ncpfs and TCP vs UDP
In-Reply-To: <45BB69BE.5060403@drzeus.cx>
Message-ID: <Pine.LNX.4.61.0701271706230.22295@yvahk01.tjqt.qr>
References: <45BA2437.4000803@drzeus.cx> <1169846450.45ba70b2698c2@imap.vc.cvut.cz>
 <Pine.LNX.4.61.0701271550210.22295@yvahk01.tjqt.qr> <45BB69BE.5060403@drzeus.cx>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>> Well, probably the same reason as NFS over UDP is discouraged. See nfs(5)
>> section WARNINGS (in short: IP fragment ID can wrap quite fast on Gigabit)
>
>I have no such warning in my nfs(5), but I am aware of this yes.
>Somewhat amusing that both nfs and ncpfs tend to default to using udp
>with this in mind. ;)

nfs has already been "fixed" to prefer tcp over udp (i.e. the default is tcp)


	-`J'
-- 
