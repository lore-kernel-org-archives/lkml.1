Return-Path: <linux-kernel-owner+w=401wt.eu-S1756728AbZCFSpN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756728AbZCFSpN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 13:45:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753566AbZCFSo6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 13:44:58 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:47235 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621AbZCFSo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 13:44:58 -0500
Date: Fri, 6 Mar 2009 18:44:52 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] toshiba_acpi: Add full hotkey support
Message-ID: <20090306184452.GA14375@srcf.ucam.org>
References: <20090306003941.GA32403@srcf.ucam.org> <20090306005234.GA32539@srcf.ucam.org> <E1Lfevu-000MzF-00.arvidjaar-mail-ru@mx48.mail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Lfevu-000MzF-00.arvidjaar-mail-ru@mx48.mail.ru>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 06, 2009 at 09:37:50PM +0300, Andrey Borzenkov wrote:

> Trivial cleanup below. Also the patch should remove /proc/acpi/toshiba/keys. It will consume hot keys 
> as soon as they are pressed, so user space watching this file has very little chances to ever see 
> them.

Mm. Actually, thinking about it, the cleanest thing to do would probably 
be to disable the input device when the proc file is opened.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
