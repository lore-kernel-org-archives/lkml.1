Return-Path: <linux-kernel-owner+w=401wt.eu-S1757337AbYDBOXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757337AbYDBOXR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 10:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754310AbYDBOXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 10:23:05 -0400
Received: from lazybastard.de ([212.112.238.170]:51872 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073AbYDBOXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 10:23:04 -0400
Date: Wed, 2 Apr 2008 16:22:45 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: Artem Bityutskiy <dedekind@yandex.ru>, LKML <linux-kernel@vger.kernel.org>,
       penberg@cs.helsinki.fi, ext-adrian.hunter@nokia.com, jwboyer@gmail.com,
       w@1wt.eu, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: UBIFS vs Logfs (was [RFC PATCH] UBIFS - new flash file system)
Message-ID: <20080402142245.GA18017@logfs.org>
References: <47F1EC20.6050600@wpkg.org> <47F1F644.4060000@yandex.ru> <47F202D9.20405@wpkg.org> <47F2071A.6010406@yandex.ru> <47F39575.40006@wpkg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <47F39575.40006@wpkg.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 April 2008 16:17:25 +0200, Tomasz Chmielewski wrote:
> 
> [1] Well, it didn't die, really. Once I removed the file which was 
> showing I/O errors and did "dd if=/dev/zero of=bigfile", there are no 
> badblocks anymore - probably remapped.

Could have been soft errors.  Heaven knows how those devices report
uncorrectable errors, but claiming the block to be bad is a good guess.
Once blocks with uncorrectable errors are rewritten (the physical
blocks, not what the device reports), they are perfectly usable again.

Jörn

-- 
They laughed at Galileo.  They laughed at Copernicus.  They laughed at
Columbus. But remember, they also laughed at Bozo the Clown.
-- unknown
