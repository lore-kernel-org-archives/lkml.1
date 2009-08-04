Return-Path: <linux-kernel-owner+w=401wt.eu-S933551AbZHDW4D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933551AbZHDW4D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 18:56:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933517AbZHDW4D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 18:56:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35208 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933510AbZHDW4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 18:56:01 -0400
Date: Tue, 4 Aug 2009 15:55:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Albin Tonnerre <albin.tonnerre@free-electrons.com>
Cc: sam@ravnborg.org, hpa@zytor.com, linux@arm.linux.org.uk, alain@knaff.lu,
       linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       albin.tonnerre@free-electrons.com,
       Phillip Lougher <phillip@lougher.demon.co.uk>
Subject: Re: [PATCH 1/6] lib/decompress_*: only include <linux/slab.h> if
 STATIC is not defined
Message-Id: <20090804155500.db6c88fa.akpm@linux-foundation.org>
In-Reply-To: <1249311501-23102-1-git-send-email-albin.tonnerre@free-electrons.com>
References: <20090731093107.GA29704@merkur.ravnborg.org>
	<1249311501-23102-1-git-send-email-albin.tonnerre@free-electrons.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  3 Aug 2009 16:58:16 +0200
Albin Tonnerre <albin.tonnerre@free-electrons.com> wrote:

> These includes were added by 079effb6933f34b9b1b67b08bd4fd7fb672d16ef to
> fix the build when using kmemtrace. However this is not necessary when
> used to create a compressed kernel, and actually creates issues (brings
> a lot of things unavailable in the decompression environment), so don't
> include it if STATIC is defined.
> 

The description "actually creates issues (brings a lot of things
unavailable in the decompression environment)" is inadequate.  Please
describe te problem this patch fixes more completely so that others
(ie: me) can decide whether this patch is needed in 2.6.32, 2.6.31. 
2.6.30, ...


This patch conflicts heavily with

http://userweb.kernel.org/~akpm/mmotm/broken-out/bzip2-lzma-remove-nasty-uncompressed-size-hack-in-pre-boot-environment.patch


What should we do about that?


