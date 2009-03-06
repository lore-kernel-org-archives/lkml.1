Return-Path: <linux-kernel-owner+w=401wt.eu-S1756634AbZCFSyE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634AbZCFSyE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 13:54:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753888AbZCFSxv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 13:53:51 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:46673 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753839AbZCFSxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 13:53:50 -0500
Date: Fri, 6 Mar 2009 18:53:40 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: dsilvers@simtec.co.uk, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] toshiba_acpi: Add full hotkey support
Message-ID: <20090306185340.GA14507@srcf.ucam.org>
References: <20090306005234.GA32539@srcf.ucam.org> <1236330536.12838.2.camel@hughsie-work.lan> <1236332843.19146.4.camel@petitemort> <20090306095623.GA6014@srcf.ucam.org> <1236333861.19146.9.camel@petitemort> <20090306100951.GA6268@srcf.ucam.org> <1236334376.19146.11.camel@petitemort> <20090306101533.GA6408@srcf.ucam.org> <1236334909.19146.16.camel@petitemort> <E1Lff74-000Hwq-00.arvidjaar-mail-ru@mx2.mail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Lff74-000Hwq-00.arvidjaar-mail-ru@mx2.mail.ru>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 06, 2009 at 09:49:36PM +0300, Andrey Borzenkov wrote:

> There are two ways to control fan here - standard ACPI and HCI. ACPI does 
> not work. Is there any standard framework for fan control (a la 
> power_supply) where HCI version could be plugged in?

Yes, it could be hooked into the thermal or hwmon layers. Thermal is 
probably best - it'll then automatically be exported as an hwmon device 
as well.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
