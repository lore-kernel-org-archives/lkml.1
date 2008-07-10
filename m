Return-Path: <linux-kernel-owner+w=401wt.eu-S1758507AbYGJPEP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758507AbYGJPEP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 11:04:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758002AbYGJPDn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 11:03:43 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:44406 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755175AbYGJPDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 11:03:42 -0400
Date: Thu, 10 Jul 2008 13:34:20 +0200
From: Pavel Machek <pavel@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Tejun Heo <tj@kernel.org>, Zhang Rui <rui.zhang@intel.com>,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH -mm 2/8] AHCI: Speed-up resume
Message-ID: <20080710113420.GB15412@elf.ucw.cz>
References: <200807100152.17755.rjw@sisk.pl> <200807100158.49341.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807100158.49341.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-07-10 01:58:48, Rafael J. Wysocki wrote:
> From: Zhang Rui <rui.zhang@intel.com>
> Subject: AHCI: Speed-up resume
> 
> During resume, sleep 1 second to wait for the HBA reset
> to finish is a waste of time.
> 
> According to the AHCI 1.2 spec,
> We should poll the HOST_CTL register,
> and return error if the host reset is not
> finished within 1 second.
> 
> Test results show that the HBA reset can be done quickly(in usecs).
> And this patch may save nearly 1 second during resume.
> 
> Signed-off-by: Zhang Rui <rui.zhang@intel.com>
> Acked-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

ACK.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
