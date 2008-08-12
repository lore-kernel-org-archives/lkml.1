Return-Path: <linux-kernel-owner+w=401wt.eu-S1753128AbYHLTpV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128AbYHLTpV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 15:45:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751538AbYHLTpI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 15:45:08 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:60800 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbYHLTpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 15:45:06 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] readdir mess
References: <20080812062241.GQ28946@ZenIV.linux.org.uk>
	<87ej4u9nf5.fsf@devron.myhome.or.jp>
	<alpine.LFD.1.10.0808121009370.3462@nehalem.linux-foundation.org>
Date: Wed, 13 Aug 2008 04:45:02 +0900
In-Reply-To: <alpine.LFD.1.10.0808121009370.3462@nehalem.linux-foundation.org>
	(Linus Torvalds's message of "Tue, 12 Aug 2008 10:18:49 -0700 (PDT)")
Message-ID: <87proe81c1.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> As to -EOVERFLOW, I suspect we are better off just dropping that whole 
> logic. Returning -EOVERFLOW and truncating the readdir listing is likely 
> much worse than the alternative. It made sense back when we needed to get 
> people to upgrade the system interfaces, now it just means that old 
> binaries won't work at all.

However, there are some similar stuff: ->st_size, ->st_nlink and
->st_ino in stat() (cp_old_stat()). Maybe EOVERFLOW is the reason for
consistency...
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
