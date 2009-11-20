Return-Path: <linux-kernel-owner+w=401wt.eu-S1754892AbZKTUOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892AbZKTUOd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 15:14:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753615AbZKTUOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 15:14:32 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:10041 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297AbZKTUOc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 15:14:32 -0500
MIME-Version: 1.0
In-Reply-To: <4B06EA3B.10500@cam.ac.uk>
References: <4B06EA3B.10500@cam.ac.uk>
Date: Fri, 20 Nov 2009 22:14:37 +0200
Message-ID: <37786d4b0911201214g65ea0f8fke1ac29b326fffe47@mail.gmail.com>
Subject: Re: [PATCH] Staging: IIO: Add tsl2560-2 support to tsl2563 driver + 
	drop tsl2561, driver.
From: Amit Kucheria <amit.kucheria@verdurent.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 20, 2009 at 9:12 PM, Jonathan Cameron <jic23@cam.ac.uk> wrote:
> These parts (tsl2560-tsl2563) are identical in interface.
> The tsl2563 driver is more advanced so makes sense to drop
> the tsl2561 driver.
>
> Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
> ---
> Greg, I've done the changes and driver removal as a single patch.
> Can separate into two if you would prefer?
>
> Amit, as promised I have tested against the tsl2561 on an imote2
> sensor board (for which the original driver was written). All seems
> to work as intended.  Only changes are addition of devices to the
> device table and Kconfig comment changes to reflect new support.
> Hope you don't mind, but I dropped the N900 reference.  These things
> are pretty common (including the new parts) and we don't really
> want to encourage people to start listing where they found. I
> haven't done any of the other changes I suggested, but can do
> those as a follow up patch if you don't mind?
>
> There are a few more similar chips with slightly different conversion
> functions.
>
> Thanks,
>
> Jonathan

Jonathan,

Changes looks good. I'll send my acks on the split up patches.

I'm working on moving this driver to the input subsystem as agreed. I
was planning to address your review comments in that rework. I can
defer that work if you want.

Regards,
Amit
