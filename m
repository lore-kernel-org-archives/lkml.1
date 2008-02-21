Return-Path: <linux-kernel-owner+w=401wt.eu-S935071AbYBUBTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935071AbYBUBTY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 20:19:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759827AbYBUBTP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 20:19:15 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:33159 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759481AbYBUBTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 20:19:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tKEAlG7m+icnUKqAoeMie4HrnRUbNllLxEMSCdSe1VigXpqcRR2U6XQrnMx0dI6kyj0ySaeZ8q2Cav8y6ovalTpTl5AvHTfBpgt/zM4SFLyk+fbvWy5t5E3wOPj7hsAn+4BC7SKRhf4I6MYI8Udu8W5FwTkvh+DAkxT9wA8z6KY=
Message-ID: <b6a2187b0802201719x39a1298j970c563a17fe6a22@mail.gmail.com>
Date: Thu, 21 Feb 2008 09:19:13 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Jesse Barnes" <jesse.barnes@intel.com>
Subject: Re: 2.6.25-rc2 System no longer powers off after suspend-to-disk. Screen becomes green.
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, "Dave Airlie" <airlied@linux.ie>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org,
       "suspend-devel List" <suspend-devel@lists.sourceforge.net>,
       "Greg KH" <gregkh@suse.de>
In-Reply-To: <200802201639.02502.jesse.barnes@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0802210101050.3576@boston.corp.fedex.com>
	 <200802201337.52247.jesse.barnes@intel.com>
	 <b6a2187b0802201635t2acb31f2n366f8ef81f119034@mail.gmail.com>
	 <200802201639.02502.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2008 at 8:39 AM, Jesse Barnes <jesse.barnes@intel.com> wrote:
>  Oops, maybe this should just be pci_choose_state instead.
>  And this change should just be reverted (leave it as PCI_D0).

drivers/char/drm/i915_drv.c: In function 'i915_suspend':
drivers/char/drm/i915_drv.c:372: warning: passing argument 1 of
'pci_choose_state' from incompatible pointer type
drivers/char/drm/i915_drv.c:373: warning: passing argument 1 of
'pci_choose_state' from incompatible pointer type

I hope those are just warning that can just be ignored.

Ok, rebooting and will get back shortly.

Thanks,
Jeff.
