Return-Path: <linux-kernel-owner+w=401wt.eu-S1753721AbYBXPV6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753721AbYBXPV6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 10:21:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750898AbYBXPVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 10:21:49 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:7739 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbYBXPVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 10:21:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tSobHbWfRqu9zt6UJ4fS1VLc0AGlApwNZALkpcnxflGaAjPWgRbnK1ZVA1v9TjuIEB0YeGhybUzoSSMb3PBAXdiYoDXilRBjz0yGs/YehFs0h42acroXyzdo532ToxyFNpPfv7/yLygH/y8CdmLxjhXt0Ptj1UHDdy1GG/kwhz8=
Message-ID: <b6a2187b0802240721t298406a3p62a85b2234eadd76@mail.gmail.com>
Date: Sun, 24 Feb 2008 23:21:47 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [PATCH] PM: Introduce PM_EVENT_HIBERNATE (was: Re: i915 hibernation patch (was: Re: 2.6.25-rc2 System no longer ...))
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, "Jesse Barnes" <jesse.barnes@intel.com>,
       "Romano Giannetti" <romano@dea.icai.upcomillas.es>,
       "Dave Airlie" <airlied@linux.ie>, "Greg KH" <gregkh@suse.de>,
       lkml <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
       "Pavel Machek" <pavel@ucw.cz>,
       "Alexey Starikovskiy" <astarikovskiy@suse.de>,
       "pm list" <linux-pm@lists.linux-foundation.org>,
       "Len Brown" <lenb@kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0802231041510.21332@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0802210101050.3576@boston.corp.fedex.com>
	 <alpine.LFD.1.00.0802221805540.21332@woody.linux-foundation.org>
	 <b6a2187b0802222036i33d5bcc2n4e3bafd6d846cc09@mail.gmail.com>
	 <200802231913.27592.rjw@sisk.pl>
	 <alpine.LFD.1.00.0802231041510.21332@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 24, 2008 at 2:43 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
>  On Sat, 23 Feb 2008, Rafael J. Wysocki wrote:
>  >
>
> > Thanks for testing.  Below is the final version of the patch with a changelog
>  > etc.
>
>  Thanks, applied.
>
>  With this, I also find that I dislike the use of suspend/resume for
>  freezing for STD a lot less. It's still too easy to get confused, but at
>  least now drivers always have total knowledge about what is really going
>  on. I'd not like this interface as a driver writer, but now it's not
>  fundamentally broken any more, just slightly confusing.

Tested and working.

Thanks again,
Jeff.
