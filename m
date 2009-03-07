Return-Path: <linux-kernel-owner+w=401wt.eu-S1756234AbZCGU1D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234AbZCGU1D (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 15:27:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755912AbZCGU0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 15:26:53 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:54448 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755574AbZCGU0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 15:26:52 -0500
Date: Sat, 7 Mar 2009 20:26:47 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Richard Hughes <hughsient@gmail.com>
Cc: Andrey Borzenkov <arvidjaar@mail.ru>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, hal@lists.freedesktop.org
Subject: Re: [PATCH] toshiba_acpi: Add full hotkey support
Message-ID: <20090307202647.GA9776@srcf.ucam.org>
References: <20090306003941.GA32403@srcf.ucam.org> <E1LfqwF-000B1G-00.arvidjaar-mail-ru@mx3.mail.ru> <20090307150640.GA3516@srcf.ucam.org> <200903071839.16508.arvidjaar@mail.ru> <20090307154424.GA3909@srcf.ucam.org> <15e53e180903071219q4ed318edt2fa8f492426c0ab6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15e53e180903071219q4ed318edt2fa8f492426c0ab6@mail.gmail.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 07, 2009 at 08:19:51PM +0000, Richard Hughes wrote:

> Mapping KEY_SUSPEND to hibernate is just insane. Can you please change
> the toshiba driver to use KEY_HIBERNATE and KEY_SUSPEND as thinkpad
> now does? Thanks.

Mapping KEY_SUSPEND to hibernate is what we've been doing for years. 
It's what hal *still does*. KEY_SLEEP has been the suspend to RAM key 
forever. How are we supposed to perform this transition? We've no idea 
how much of userspace makes the same assumption.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
