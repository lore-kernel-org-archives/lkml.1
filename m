Return-Path: <linux-kernel-owner+w=401wt.eu-S1753673AbYCLSGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673AbYCLSGS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 14:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751044AbYCLSGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 14:06:09 -0400
Received: from anyanka.rfc1149.net ([81.56.47.149]:38915 "EHLO
	mail2.rfc1149.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbYCLSGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 14:06:08 -0400
To: Christian Kujau <lists@nerdbynature.de>
Cc: Eric Sandeen <sandeen@sandeen.net>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.25-rc hangs
References: <alpine.DEB.1.00.0803072116420.7723@sheep.housecafe.de>
	<20080307224040.GV155259@sgi.com>
	<alpine.DEB.1.00.0803080032020.7723@sheep.housecafe.de>
	<alpine.DEB.1.00.0803080251110.4325@sheep.housecafe.de>
	<alpine.DEB.1.00.0803090658040.5349@sheep.housecafe.de>
	<47D413FA.50602@sandeen.net>
	<alpine.DEB.1.00.0803091858480.5349@sheep.housecafe.de>
	<47D42AD6.10500@sandeen.net>
	<alpine.DEB.1.00.0803091934090.5349@sheep.housecafe.de>
Date: Wed, 12 Mar 2008 19:06:06 +0100
In-Reply-To: <alpine.DEB.1.00.0803091934090.5349@sheep.housecafe.de> (Christian Kujau's message of "Sun\, 9 Mar 2008 19\:49\:36 +0100 \(CET\)")
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
From: Samuel Tardieu <sam@rfc1149.net>
Organization: RFC 1149 (see http://www.rfc1149.net/)
Content-Transfer-Encoding: 8bit
X-WWW: http://www.rfc1149.net/sam
X-Jabber: <sam@rfc1149.net> (see http://www.jabber.org/)
X-OpenPGP-Fingerprint: 79C0 AE3C CEA8 F17B 0EF1  45A5 F133 2241 1B80 ADE6 (see http://www.gnupg.org/)
Message-Id: <2008-03-12-19-06-06+trackit+sam@rfc1149.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Christian" == Christian Kujau <lists@nerdbynature.de> writes:

Christian> After rebooting to a working kernel I can now do either:

Christian>  1) mark the current one as "bad" [...]

Christian>  2) although booting failed, I still mark it "good" [...]

Can't you skip it with "git bisect skip" in this case? (I've never
tried "skip" but from "git bisect" documentation it does what you
want, and "git bisect" will select a nearby revision)

  Sam
-- 
Samuel Tardieu -- sam@rfc1149.net -- http://www.rfc1149.net/

