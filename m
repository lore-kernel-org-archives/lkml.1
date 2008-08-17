Return-Path: <linux-kernel-owner+w=401wt.eu-S1754008AbYHQTM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008AbYHQTM7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 15:12:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750827AbYHQTMw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 15:12:52 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:39400 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750806AbYHQTMv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 15:12:51 -0400
Date: Sun, 17 Aug 2008 22:10:39 +0300
From: Adrian Bunk <bunk@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, tglx@linutronix.de,
       mingo@redhat.com
Subject: Re: [PATCH] x86, tsc: fix section mismatch warning
Message-ID: <20080817191038.GD24619@cs181140183.pp.htv.fi>
References: <20080810220740.GA27349@joi> <489FC913.1050509@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <489FC913.1050509@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 10, 2008 at 10:07:31PM -0700, H. Peter Anvin wrote:
> Thanks!
>
> I have pulled these four patches into tip:x86/cleanups.

Section fixes are not cleanups but bugfixes.

E.g. this patch by Marcin fixes the following 2.6.27 regression
(that was found 4 days after you applied his patch):
  http://bugzilla.kernel.org/show_bug.cgi?id=11330

Can you make sure that Marcin's bugfixes makes it into 2.6.27?

> 	-hpa

TIA
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

