Return-Path: <linux-kernel-owner+w=401wt.eu-S934751AbZLGIrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934751AbZLGIrR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 03:47:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933632AbZLGIrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 03:47:16 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:38549 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933585AbZLGIrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 03:47:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=Cw8XzGhnl8RdD0tzi6VAH//nklbeYJt4k2BMLQ53W0J52HQitilccidYRlMafEezVy
         aTBS81LWDTrmn4FMLu9KAQdhVnv7vUIe5Pii1kbwhfvkkqinS3Z9MdT/6cE/vJRZIGxr
         ahVkhj0zjKzGQgBnuG2vQ6BjrTGe7r9+Qfp/Y=
From: Peter Korsgaard <jacmet@sunsite.dk>
To: phillip@lougher.demon.co.uk
Cc: akpm@linux-foundation.org, linux-embedded@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       phillip.lougher@gmail.com, tim.bird@am.sony.com
Subject: Re: [PATCH 0/9] Squashfs: Add support for LZMA compressed filesystems
References: <E1NHYun-000287-Vq@dylan.lougher.demon.co.uk>
Date: Mon, 07 Dec 2009 09:47:17 +0100
In-Reply-To: <E1NHYun-000287-Vq@dylan.lougher.demon.co.uk>
	(root@lougher.demon.co.uk's message of "Mon, 07 Dec 2009 08:25:53
	+0000")
Message-ID: <87tyw3p3vu.fsf@macbook.be.48ers.dk>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "root" == root  <root@lougher.demon.co.uk> writes:

 root> Hi,
 root> The following patches add LZMA decompression support to Squashfs, using the
 root> in-kernel LZMA decompression library.

 root> The patches also add a decompression framework to Squashfs.
 root> This allows LZMA decompression to be added cleanly, and it allows
 root> additional decompressors to be easily added in the future.

 root> To enable the in-kernel LZMA decompression code to be used by Squashfs,
 root> there are two patches to the lzma code itself: one to make lzma available
 root> to non-init code, and one to make lzma reentrant.  These are obviously
 root> not restricted to Squashfs, but are needed by any non-init code that
 root> may wish to use lzma compression.

Nice, do you also have an mksquashfs with lzma support?

-- 
Bye, Peter Korsgaard
