Return-Path: <linux-kernel-owner+w=401wt.eu-S1755574AbYJOURV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574AbYJOURV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 16:17:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753342AbYJOURD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 16:17:03 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:39541 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932AbYJOURB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 16:17:01 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Christoph Hellwig <hch@infradead.org>
Cc: viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] vfs: remove unnecessary fsnotify_d_instantiate()
References: <fcaad2cb3e848f5f6f1126623.ps@mail.parknet.co.jp>
	<e015bca83e848f5f6f2226623.ps@mail.parknet.co.jp>
	<7754d3f83e848f5f6f2326623.ps@mail.parknet.co.jp>
	<524881153e848f5f6f3426623.ps@mail.parknet.co.jp>
	<20081015194334.GB24892@infradead.org>
Date: Thu, 16 Oct 2008 05:16:58 +0900
In-Reply-To: <20081015194334.GB24892@infradead.org> (Christoph Hellwig's
	message of "Wed, 15 Oct 2008 15:43:34 -0400")
Message-ID: <878wsppq9x.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@infradead.org> writes:

> On Wed, Oct 15, 2008 at 10:58:11PM +0900, OGAWA Hirofumi wrote:
>> 
>> This calls d_move(), so fsnotify_d_instantiate() is unnecessary like
>> rename path.
>
> fsnotify_d_instantiate and fsnotify_d_move call into different inotify
> functions.  Did you verify that this really does the right thing?
> (Sorry, not in a mood to look into idiotify code..)

Yes. I checked it.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
