Return-Path: <linux-kernel-owner+w=401wt.eu-S1761790AbYEHTmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761790AbYEHTmp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 15:42:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753888AbYEHTmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 15:42:31 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:49632 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429AbYEHTma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 15:42:30 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Christoph Hellwig <hch@infradead.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, akpm@linux-foundation.org,
       viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, sds@tycho.nsa.gov, jmorris@namei.org,
       casey@schaufler-ca.com
Subject: Re: [patch 07/24] fat: dont call notify_change
References: <20080506091327.259950960@szeredi.hu>
	<20080506091414.440652004@szeredi.hu>
	<20080508165724.GD13914@infradead.org>
Date: Fri, 09 May 2008 04:42:12 +0900
In-Reply-To: <20080508165724.GD13914@infradead.org> (Christoph Hellwig's
	message of "Thu, 8 May 2008 12:57:24 -0400")
Message-ID: <873aospoq3.fsf@duaron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@infradead.org> writes:

> Actually I think we want the security_inode_setattr.  This is an
> implicit chmode when switching the ATTR_RO flag on and off and we should
> have the full security check for it.  Then again I'm not sure the
> security modules care about this level of detail because there's
> probably even worse ioctl hidden somewhere.
>
> Ccing the Selinux guys and Casey in case they care.

Sounds good.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
