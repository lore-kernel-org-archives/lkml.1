Return-Path: <linux-kernel-owner+w=401wt.eu-S1760948AbXENWlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760948AbXENWlq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 18:41:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756670AbXENWli
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 18:41:38 -0400
Received: from mail.parknet.jp ([210.171.160.80]:1846 "EHLO parknet.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756822AbXENWlh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 18:41:37 -0400
X-AuthUser: hirofumi@parknet.jp
To: Hubertus Grobbel <hubertus@grobbel.net>
Cc: Linux List <linux-kernel@vger.kernel.org>
Subject: Re: O_DIRECT for FAT
References: <200705150103.02398.hubertus@grobbel.net>
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Tue, 15 May 2007 07:41:27 +0900
In-Reply-To: <200705150103.02398.hubertus@grobbel.net> (Hubertus Grobbel's message of "Tue\, 15 May 2007 01\:02\:51 +0100")
Message-ID: <87sl9z3u5k.fsf@duaron.myhome.or.jp>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hubertus Grobbel <hubertus@grobbel.net> writes:

> I found out, that the option O_DIRECT for opening a file on a fat-
> filesystem successfully completes. But reading and writing to that
> file leads to EINVAL errors (using kernel 2.6.18).

EINVAL may be meaning the memory alignment which you passed to syscall
is wrong.

> Do you see a way to solve my problem by any workaround? Is O_DIRECT
> support for fat-fs feasible in future?

The fatfs is supporting O_DIRECT for read, for write it's partially
supporting (can't extend file size).
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
