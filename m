Return-Path: <linux-kernel-owner+w=401wt.eu-S1754236AbXKJPm5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236AbXKJPm5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 10:42:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754188AbXKJPmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 10:42:12 -0500
Received: from ns.suse.de ([195.135.220.2]:32793 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754169AbXKJPmK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 10:42:10 -0500
From: Frank Seidel <fseidel@suse.de>
Organization: SUSE LINUX Products GmbH
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [RFC 6/13] Char: nozomi, reorder and cleanup probe, remove
Date: Sat, 10 Nov 2007 16:42:07 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org
References: <29761185991768728185.slaby@pripojeni.net>
In-Reply-To: <29761185991768728185.slaby@pripojeni.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711101642.08808.fseidel@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Samstag 10 November 2007 00:46:51, you (Jiri Slaby) wrote:
> nozomi, reorder and cleanup probe, remove
> - remap space after requesting region, to not map something we cannot use
>   anyway
> - init spin lock before request_irq, because due to shared irq debug, isr
>   might be called immediately, where the lock is being held
> - remove INIT_LIST_HEAD before list_add, it's useless, because list_add
>   re-sets prev and next
> - reorder cleanup to be the same as fail path of probe (or in other words,
>   the reverse of probe)
> - no need to call nozomi_setup_private_data in remove, pointers are set in
>   probe

All perfect catches IMHO. Applied without changes.

Thanks,
Frank
