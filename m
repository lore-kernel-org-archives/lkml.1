Return-Path: <linux-kernel-owner+w=401wt.eu-S1756562AbYLaLjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562AbYLaLjk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 06:39:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755537AbYLaLjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 06:39:32 -0500
Received: from main.gmane.org ([80.91.229.2]:40512 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755139AbYLaLjb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 06:39:31 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: mismatch_cnt, random bitflips, silent corruption(?), mdadm/sw
 raid[156]
Date: Wed, 31 Dec 2008 12:39:16 +0100
Organization: Technische Universitaet Ilmenau, Germany
Message-ID: <slrnglmmf7.agm.Mario.Holbe@darkside.dyn.samba-tng.org>
References: <alpine.DEB.1.10.0812250435260.12329@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: p4fd56919.dip.t-dialin.net
User-Agent: slrn/pre1.0.0-2 (Linux)
Cancel-Lock: sha1:FEG4Xv/B/Att+LRIUd2MWss3SPw=
Cc: linux-raid@vger.kernel.org, smartmontools-support@lists.sourceforge.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
> Options/alternatives for maintaining data integrity?
> 3. Keep an md5sum for each file on the filesystem and run daily checks?

I'm doing this since about 6 years now with all of my files and I never
experienced any silent corruption.
I also regularly experience MD mismatch_cnt effects on RAID1 with ext2/3
filesystems with heavy file removal/creation load (even before MD
implemented its self-check features - I cmp-ed and corrected them
manually before) and they all seem to have been related to metadata,
i.e. inodes.


regards
   Mario
-- 
[mod_nessus for iauth]
<delta> "scanning your system...found depreciated OS...found
        hole...installing new OS...please reboot and reconnect now"

