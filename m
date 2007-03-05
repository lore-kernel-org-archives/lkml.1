Return-Path: <linux-kernel-owner+w=401wt.eu-S1030274AbXCENjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030274AbXCENjR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 08:39:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030319AbXCENjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 08:39:17 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43171 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030274AbXCENjQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 08:39:16 -0500
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20070305014951.GD3441@stusta.de> 
References: <20070305014951.GD3441@stusta.de>  <20070304152506.GC3441@stusta.de> <20070304041111.1d2774e7.akpm@linux-foundation.org> <20070302030026.5eef0c92.akpm@linux-foundation.org> <20070302030405.22f78999.akpm@linux-foundation.org> <45EAB46F.1030709@gmail.com> <14778.1173021069@redhat.com> <15200.1173022514@redhat.com> 
To: Adrian Bunk <bunk@stusta.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>
Subject: Re: [-mm patch] fix the ROMFS_* dependencies 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Mon, 05 Mar 2007 13:36:55 +0000
Message-ID: <14518.1173101815@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk <bunk@stusta.de> wrote:

> OK, what about the patch below?

How many goats did you have to sacrifice to get that to work?  I like it with
just one very minor niggle: if CONFIG_BLOCK=y, CONFIG_MTD=y, CONFIG_ROMFS_FS=y
CONFIG_EMBEDDED=y and CONFIG_ROMFS_ON_BLOCK=y then the CONFIG_ROMFS_ON_BLOCK
configuration item disappears and reappears depending on the state of
CONFIG_ROMFS_ON_MTD.  But, as I said, it's a very minor niggle.

Acked-By: David Howells <dhowells@redhat.com>
