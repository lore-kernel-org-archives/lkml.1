Return-Path: <linux-kernel-owner+w=401wt.eu-S1754517AbYJOUZD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517AbYJOUZD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 16:25:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752855AbYJOUYx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 16:24:53 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:57416 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbYJOUYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 16:24:53 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Christoph Hellwig <hch@infradead.org>
Cc: viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] vfs: replace parent == dentry->d_parent by IS_ROOT()
References: <fcaad2cb3e848f5f6f1126623.ps@mail.parknet.co.jp>
	<20081015194519.GD24892@infradead.org>
Date: Thu, 16 Oct 2008 05:24:49 +0900
In-Reply-To: <20081015194519.GD24892@infradead.org> (Christoph Hellwig's
	message of "Wed, 15 Oct 2008 15:45:19 -0400")
Message-ID: <874p3dppwu.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@infradead.org> writes:

> Looks correct, but I'm not entirely sure it's a worthwhile cleanup,
> noth version are about the same level of readability to me.

Yes. However, I think mix is not readable (and not grep friendly).
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
