Return-Path: <linux-kernel-owner+w=401wt.eu-S1755251AbYLIUVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251AbYLIUVA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 15:21:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754615AbYLIUUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 15:20:52 -0500
Received: from mail-fx0-f19.google.com ([209.85.220.19]:34742 "EHLO
	mail-fx0-f19.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754500AbYLIUUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 15:20:51 -0500
X-Greylist: delayed 939 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Dec 2008 15:20:51 EST
Date: Tue, 9 Dec 2008 20:50:57 +0100
From: Frederik Deweerdt <frederik.deweerdt@xprog.eu>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: mingo@redhat.com, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/33] x86: Make static
Message-ID: <20081209195057.GA7394@gambetta>
References: <493EA286.7080500@gmail.com> <493EA3BE.4050206@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <493EA3BE.4050206@gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 09, 2008 at 05:58:38PM +0100, Roel Kluin wrote:
> -int add_efi_memmap;
> +static int add_efi_memmap;
>  EXPORT_SYMBOL(add_efi_memmap);

This is really an extern missing.

Regards,
Frederik
