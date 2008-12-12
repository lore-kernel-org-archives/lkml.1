Return-Path: <linux-kernel-owner+w=401wt.eu-S1759324AbYLLRD6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759324AbYLLRD6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 12:03:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757773AbYLLRDt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 12:03:49 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:50476 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757646AbYLLRDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 12:03:48 -0500
Date: Fri, 12 Dec 2008 10:03:47 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: [PATCH v2] Add preadv and pwritev system calls.
Message-ID: <20081212170347.GR26095@parisc-linux.org>
References: <1229090440-32120-1-git-send-email-kraxel@redhat.com> <20081212152929.GM26095@parisc-linux.org> <494287D4.2070909@redhat.com> <20081212155113.GO26095@parisc-linux.org> <49428AFD.5090009@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49428AFD.5090009@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2008 at 05:02:05PM +0100, Gerd Hoffmann wrote:
> I'd *really* hate it to have the same system call with different
> argument ordering on different systems though.  Especially when swapping
> two integer values, so gcc wouldn't error out on wrong usage.

We can always permute it further:

int fd, int vlen, loff_t pos, const struct *

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
