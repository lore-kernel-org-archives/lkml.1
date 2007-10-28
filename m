Return-Path: <linux-kernel-owner+w=401wt.eu-S1754707AbXJ1Q3v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707AbXJ1Q3v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 12:29:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752080AbXJ1Q3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 12:29:43 -0400
Received: from ausc60pc101.us.dell.com ([143.166.85.206]:23795 "EHLO
	ausc60pc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519AbXJ1Q3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 12:29:42 -0400
X-Greylist: delayed 577 seconds by postgrey-1.27 at vger.kernel.org; Sun, 28 Oct 2007 12:29:42 EDT
DomainKey-Signature: s=smtpout; d=dell.com; c=nofws; q=dns; b=nqXMuPvcVi1yv4LOqpJkDZgX6rU3GdPfKQrwoOvZtoAHwIpHYipaT8ew+gPG7ro5Ihn/tJ3/H6oTdbsvOrTea/FMrIy+qBZdmQFhUGQPiucNUtzwKulHOtdPDBadAWiu;
X-IronPort-AV: E=Sophos;i="4.21,339,1188795600"; 
   d="scan'208";a="402189651"
Date: Sun, 28 Oct 2007 11:19:55 -0500
From: Matt Domsch <Matt_Domsch@dell.com>
To: jack@antonello.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Dell laptop backlight driver
Message-ID: <20071028161955.GF23359@auslistsprd01.us.dell.com>
References: <4724B4F5.80004@antonello.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4724B4F5.80004@antonello.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 28, 2007 at 05:12:37PM +0100, jack@antonello.org wrote:
> Hello,
> this driver implements backlight control on Dell laptops
> which use SMI  for changing brightness levels.
> 
> The driver is INCOMPLETE since it is unable to probe some required 
> parameters
> in order to perform backlight control. Such parameters are found in a Dell
> proprietary DMI table which should be parsed. For now external tools may be
> used to find these parameters by hand. So if you intend to try this out,
> FIRST write your laptop model parameters correctly inside the source code
> as explained in Documentation/dell-laptop.txt.
> 
> Parts of this driver may also be used to provide additional functionalities
> similarly to the drivers/misc/*-laptop.c drivers.

Why is this better done in the kernel rather than in userspace with
libsmbios as you've noted?

-- 
Matt Domsch
Linux Technology Strategist, Dell Office of the CTO
linux.dell.com & www.dell.com/linux
