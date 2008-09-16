Return-Path: <linux-kernel-owner+w=401wt.eu-S1756547AbYIPQJ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547AbYIPQJ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 12:09:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753187AbYIPQJV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 12:09:21 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:47221 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752677AbYIPQJU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 12:09:20 -0400
Date: Tue, 16 Sep 2008 19:09:02 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Ulrich Drepper <drepper@redhat.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>, linux-kernel@vger.kernel.org,
       Davide Libenzi <davidel@xmailserver.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] linux/inotify.h: do not include <linux/fcntl.h> in
	userspace
Message-ID: <20080916160902.GF1400@cs181140183.pp.htv.fi>
References: <1221567763-17060-1-git-send-email-kirill@shutemov.name> <20080916125802.GA15951@cs181140183.pp.htv.fi> <20080916130234.GA17082@localhost.localdomain> <48CFBE51.1060200@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <48CFBE51.1060200@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2008 at 07:10:25AM -0700, Ulrich Drepper wrote:
> Kirill A. Shutemov wrote:
> >> What is the error message?
> > 
> > /usr/include/asm-generic/fcntl.h:117: error: redefinition of 'struct
> > flock'
> 
> And?  None of these programs should use <linux/inotify.h>.  There has
> for the longest time been a <sys/inotify.h> header which doesn't need
> any kernel headers.  In fact, <linux/inotify.h> should not be exported.

Even if userspace applications shouldn't use it directly this doesn't 
sound right:

We shouldn't force all libc implementations to copy the contents into a 
private header.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

