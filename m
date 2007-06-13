Return-Path: <linux-kernel-owner+w=401wt.eu-S1756867AbXFMWDI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756867AbXFMWDI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 18:03:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754401AbXFMWC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 18:02:56 -0400
Received: from smtp01.cdmon.com ([86.109.99.230]:54185 "EHLO smtp01.cdmon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753323AbXFMWCz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 18:02:55 -0400
Date: Thu, 14 Jun 2007 01:02:05 +0200
From: DervishD <lkml@dervishd.net>
To: "Ph. Marek" <philipp.marek@bmlv.gv.at>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ext2 on flash memory
Message-ID: <20070613230205.GA4815@DervishD>
Mail-Followup-To: "Ph. Marek" <philipp.marek@bmlv.gv.at>,
	linux-kernel@vger.kernel.org
References: <20070611173611.GA2433@DervishD> <200706131516.41142.philipp.marek@bmlv.gv.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200706131516.41142.philipp.marek@bmlv.gv.at>
User-Agent: Mutt/1.4.2.3i
Organization: DervishD
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    Hi Philipp :))

 * Ph. Marek <philipp.marek@bmlv.gv.at> dixit:
> >     I was just wondering if, apart from the excessive wear, there were
> > other reasons. One of the reasons I would like to use a good filesystem
> > for a pendrive is to be able to store file metadata (UID, GID, mode,
> > etc.) properly, for example to store a "live" copy of my home dir in the
> > pendrive.
> If it would be enough to have a backup (with meta-data), that needs some 
> software to be read again, you could also try fsvs (http://fsvs.tigris.org).
> 
> That does a full filesystem versioning (with owner, group, mode and mtime) 
> into a subversion repository. This would have the benefit that you could keep 
> the "prefered" filesystem, but have a (versioned!) backup of your data.

    Your message is very peculiar... because I already have a similar
thing working on my system ;))) I tried FSVS and I didn't like it fully
(don't ask me why, I don't even remember, that was a time ago), so I
wrote my own system.

    Instead of a complex solution, I opted for a simple (but ad-hoc)
solution, writing a pre-commit-hook in Perl and a couple of files to
store the metadata. Very simple but I have all my system configuration
files (and other files that I want to have versioned) under SVN.

    Thanks for your suggestion anyway, because I think that the concept
(having versioned system files) is interesting and very useful :))

    Raúl Núñez de Arenas Coronado

-- 
Linux Registered User 88736 | http://www.dervishd.net
It's my PC and I'll cry if I want to... RAmen!
