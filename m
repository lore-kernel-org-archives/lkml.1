Return-Path: <linux-kernel-owner+w=401wt.eu-S1756178AbZA0PvL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756178AbZA0PvL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 10:51:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753457AbZA0Puz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 10:50:55 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45345 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752084AbZA0Puy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 10:50:54 -0500
Date: Tue, 27 Jan 2009 07:50:23 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jeff Garzik <jeff@garzik.org>, Tejun Heo <tj@kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata fixes
In-Reply-To: <20090127073055.GA30360@havoc.gtf.org>
Message-ID: <alpine.LFD.2.00.0901270748290.3123@localhost.localdomain>
References: <20090127073055.GA30360@havoc.gtf.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 27 Jan 2009, Jeff Garzik wrote:
> 
> Please pull from 'upstream-linus' branch of
> master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus
> 
> to receive the following updates:
> 
>  drivers/ata/Kconfig              |    6 ++--
>  drivers/ata/libata-sff.c         |   12 ++++++-
>  drivers/ata/pata_rb532_cf.c      |    2 -
>  drivers/ata/pata_via.c           |   22 +++++++++---
>  drivers/ata/sata_mv.c            |   56 ++++++++++++++----------------
>  drivers/ata/sata_nv.c            |   70 +++++++++++++++++++++++--------------
>  include/linux/pci_ids.h          |    4 ++
>  7 files changed, 104 insertions(+), 68 deletions(-)
>  delete mode 100644 arch/arm/mach-integrator/clock.h

Hmm. That delete of the empty file is "correct" (and probably came as a 
result of somebody doing "make distclean" which deletes empty files), but 
should not have been committed as part of "libata-sff: fix incorrect EH 
message".

Seems to be a mistake, and a small one, but still.. Be more careful.

			Linus
