Return-Path: <linux-kernel-owner+w=401wt.eu-S1756912AbYJVQis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756912AbYJVQis (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 12:38:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754351AbYJVQih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 12:38:37 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:62472 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753245AbYJVQif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 12:38:35 -0400
Date: Wed, 22 Oct 2008 18:38:34 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
cc: akpm@linux-foundation.org, linux-embedded@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       tim.bird@am.sony.com
Subject: Re: Subject: [PATCH 09/16] Squashfs: uid/gid lookup operations
In-Reply-To: <E1KqrTX-0001xo-4N@dylan>
Message-ID: <Pine.LNX.4.64.0810221838020.5634@vixen.sonytel.be>
References: <E1KqrTX-0001xo-4N@dylan>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-983614544-1224693514=:5634"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-983614544-1224693514=:5634
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Fri, 17 Oct 2008, Phillip Lougher wrote:
> --- /dev/null
> +++ b/fs/squashfs/id.c

> +__le64 *read_id_index_table(struct super_block *s, long long id_table_start,
> +	unsigned short no_ids)
> +{
> +	unsigned int length = SQUASHFS_ID_BLOCK_BYTES(no_ids);
> +	__le64 *id_table;
> +
> +	TRACE("In read_id_index_table, length %d\n", length);
> +
> +	/* Allocate id index table */
> +	id_table = kmalloc(length, GFP_KERNEL);
                           ^^^^^^
Can this ever be larger than 64 KiB?

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
---584349381-983614544-1224693514=:5634--
