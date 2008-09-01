Return-Path: <linux-kernel-owner+w=401wt.eu-S1752374AbYIAWx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374AbYIAWx3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 18:53:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751414AbYIAWxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 18:53:19 -0400
Received: from nebensachen.de ([195.34.83.29]:48180 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750984AbYIAWxS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 18:53:18 -0400
X-Hashcash: 1:20:080901:bzolnier@gmail.com::QWeo1EdsTi+Msh/s:00000000000000000000000000000000000000000000Zyw
X-Hashcash: 1:20:080901:linux-ide@vger.kernel.org::fAg2/sA5FBsX03B6:000000000000000000000000000000000000HVeh
X-Hashcash: 1:20:080901:linux-kernel@vger.kernel.org::5YGrh6YIA7E/lNtT:0000000000000000000000000000000008tP6
From: Elias Oltmanns <eo@nebensachen.de>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ide: Build fix for CONFIG_IDE_PROC_FS=n
References: <20080829213217.4826.91622.stgit@denkblock.local>
	<200808311752.06818.bzolnier@gmail.com>
Date: Tue, 02 Sep 2008 00:52:55 +0200
In-Reply-To: <200808311752.06818.bzolnier@gmail.com> (Bartlomiej
	Zolnierkiewicz's message of "Sun, 31 Aug 2008 17:52:05 +0200")
Message-ID: <878wub1nso.fsf@denkblock.local>
User-Agent: Gnus/5.110007 (No Gnus v0.7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> On Friday 29 August 2008, Elias Oltmanns wrote:
>> Recent changes have broken compilation when CONFIG_IDE_PROC_FS is not set.
>> 
>> Signed-off-by: Elias Oltmanns <eo@nebensachen.de>
>
> Thanks!
>
> I integrated your fixes into guilty patches ("ide-floppy: move /proc handling
> to ide-floppy_proc.c" and "ide-disk: move /proc handling to ide-disk_proc.c")
> to preserve bisection.

Yes, that's fine with me, but in the case of ide-disk_proc.h things
apparently went wrong. As of next-20080901, I still have the line

ide-disk_mod-y += ide-disk.o ide-disk_ioctl.o ide-disk_proc.o

in the Makefile. Could you please truncate that line appropriately?

Regards,

Elias
