Return-Path: <linux-kernel-owner+w=401wt.eu-S1758020AbZDQVH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758020AbZDQVH1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 17:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752930AbZDQVHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 17:07:13 -0400
Received: from smtp-vbr17.xs4all.nl ([194.109.24.37]:2899 "EHLO
	smtp-vbr17.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370AbZDQVHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 17:07:12 -0400
Date: Fri, 17 Apr 2009 23:07:01 +0200
From: Folkert van Heusden <folkert@vanheusden.com>
To: Anton Ertl <anton@mips.complang.tuwien.ac.at>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Out-of-order writing by disk drives
Message-ID: <20090417210700.GD10554@vanheusden.com>
References: <E1LrHX3-0003u5-2G@a4.complang.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1LrHX3-0003u5-2G@a4.complang.tuwien.ac.at>
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Read-Receipt-To: <folkert@vanheusden.com>
Reply-By: Sat Apr 18 21:15:00 CEST 2009
X-Message-Flag: MultiTail - tail on steroids
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I have released a new version of hdtest, a program that tests whether
> hard disks write out-of-order relative to the order that the writes
> were passed to them from the OS.  You find the program at
> http://www.complang.tuwien.ac.at/anton/hdtest/

Not sure if it matters but it seems open-iscsi (both target and
initiator are linux systems) works fine with respect to the write
barriers: while running hdtest on an iscsi device I suddenly stopped the
traffic flowing using an iptables DROP-rule. Then of course I stopped
the iscsi initiator, removed the rules, restarted the initator and ran
hdcheck: all above the line have the correct magic.


Folkert van Heusden

-- 
www.vanheusden.com/multitail - win een vlaai van multivlaai! zorg
ervoor dat multitail opgenomen wordt in Fedora Core, AIX, Solaris of
HP/UX en win een vlaai naar keuze
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
