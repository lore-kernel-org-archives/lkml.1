Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707Ab0CDAYe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 19:24:34 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:45806 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529Ab0CDAY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 19:24:28 -0500
Date: Thu, 4 Mar 2010 00:24:24 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ACPI / PM: Move ACPI video resume to a PM notifier
Message-ID: <20100304002424.GA8204@srcf.ucam.org>
References: <201003040125.30091.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201003040125.30091.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 04, 2010 at 01:25:30AM +0100, Rafael J. Wysocki wrote:
> There is a problem with the ACPI video resume routine that it's
> executed before the GPU that may be accessed by it.  To fix this
> issue, move the ACPI video resume to a power management notifier,
> so that it's executed after resuming all devices, including the GPU.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Matthew Garrett <mjg@redhat.com>

-- 
Matthew Garrett | mjg59@srcf.ucam.org
