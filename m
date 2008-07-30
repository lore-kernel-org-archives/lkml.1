Return-Path: <linux-kernel-owner+w=401wt.eu-S1762574AbYG3PEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762574AbYG3PEb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 11:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756801AbYG3PEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 11:04:21 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:48576 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725AbYG3PET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 11:04:19 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: "Darren Jenkins" <darrenrjenkins@gmail.com>
Cc: "kernel Janitors" <kernel-janitors@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fs/fat/dir.c fix resource leak
References: <1217289813.9367.9.camel@localhost.localdomain>
	<87hca8alz6.fsf@devron.myhome.or.jp>
	<87d4kwalh1.fsf@devron.myhome.or.jp>
	<82faac5b0807300215j6cd9d938t7058080a65ffff74@mail.gmail.com>
Date: Thu, 31 Jul 2008 00:04:15 +0900
In-Reply-To: <82faac5b0807300215j6cd9d938t7058080a65ffff74@mail.gmail.com>
	(Darren Jenkins's message of "Wed, 30 Jul 2008 19:15:46 +1000")
Message-ID: <87wsj3l8gg.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Darren Jenkins" <darrenrjenkins@gmail.com> writes:

> bufname is not used anymore ? I'm not sure what you mean? are you
> talking about an external tree ?

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=fs/fat/dir.c;h=cd4a0162e10d6dea7507507cf25a13fd93d93f04;hb=HEAD#l356

No, about current Linus tree. I meant, bufname is used actually, but
it's not allocated dynamically by __getname().

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
