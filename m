Return-Path: <linux-kernel-owner+w=401wt.eu-S1754937AbZCGPoj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754937AbZCGPoj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 10:44:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752991AbZCGPoa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 10:44:30 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:38969 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656AbZCGPo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 10:44:29 -0500
Date: Sat, 7 Mar 2009 15:44:24 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       hal@lists.freedesktop.org, Richard Hughes <hughsient@gmail.com>
Subject: Re: [PATCH] toshiba_acpi: Add full hotkey support
Message-ID: <20090307154424.GA3909@srcf.ucam.org>
References: <20090306003941.GA32403@srcf.ucam.org> <E1LfqwF-000B1G-00.arvidjaar-mail-ru@mx3.mail.ru> <20090307150640.GA3516@srcf.ucam.org> <200903071839.16508.arvidjaar@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903071839.16508.arvidjaar@mail.ru>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 07, 2009 at 06:38:53PM +0300, Andrey Borzenkov wrote:

> - patch toshiba_acpi to return KEY_SUSPEND/KEY_HIBERNATE instead of 
> KEY_SLEEP/KEY_SUSPEND. This depends on commit 
> 6932b918e05b06165ed3457a9f3aa279099a7cbd in linux-next.
> 
> - patch HAL to recognize KEY_HIBERNATE and return "suspend" for 
> KEY_SUSPEND; right now it is:
> 
>         [KEY_SLEEP] = "sleep",
>         [KEY_SUSPEND] = "hibernate",

Ugh. Why are we changing this? The semantics were pretty clear before. 
The KEY_SUSPEND to hibernate mapping was decided years ago, and it's 
clearly an incompatible change as far as userspace goes.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
