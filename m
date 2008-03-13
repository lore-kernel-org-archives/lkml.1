Return-Path: <linux-kernel-owner+w=401wt.eu-S1753967AbYCMHk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967AbYCMHk0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 03:40:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751718AbYCMHkM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 03:40:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:35824 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751482AbYCMHkK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 03:40:10 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Andrew Morton <akpm@linux-foundation.org>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: Re: [GIT PATCH] ACPI patches for 2.6.25-rc5
Date: Thu, 13 Mar 2008 03:38:05 -0400
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrea Arcangeli <andrea@qumranet.com>
References: <200803130214.36861.lenb@kernel.org> <20080312234516.bb079cc5.akpm@linux-foundation.org>
In-Reply-To: <20080312234516.bb079cc5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803130338.05928.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 March 2008, Andrew Morton wrote:
> On Thu, 13 Mar 2008 02:14:36 -0400 Len Brown <lenb@kernel.org> wrote:
> 
> > please pull from: 
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release
> > 
> > A bunch of small regression fixes, bug fixes, and a couple of minor cleanups.
> 
> I hope Rafael knows how to cross-reference the regression fixes against his list?

Rafael files them in bugzilla, if they're not already there.
I close them when the patches hit upstream.
Simple, huh?

> I'm sitting on five ACPI patches which look like they (or alternatives?) should
> be in 2.6.25:
> 
> 
> http://userweb.kernel.org/~akpm/mmotm/broken-out/acpi-ec-revert-208c70a45624400fafd7511b96bc426bf01f8f5e.patch
> 
>   This was too poorly changelogged for me to remember what problem it
>   solves, but it seemed important at the time.

that one is included in this batch, it is bugzilla 10100.

> http://userweb.kernel.org/~akpm/mmotm/broken-out/drivers-acpi-asus_acpic-correct-use-of-and.patch
> 
>   Fix logic error in asus_acpi.c

i'll look at that one.

> http://userweb.kernel.org/~akpm/mmotm/broken-out/drivers-acpi-asus_acpic-correct-use-of-and.patch
> 
>   Fix an overrun.

this is the same url as above.

> http://userweb.kernel.org/~akpm/mmotm/broken-out/revert-acpi-thermal-fixup.patch
> 
>   Hopeully fix a regression which Andrea Arcangeli hit.  Although I'm not sure
>   that he has confirmed that this revert actually works?

We're waiting for Andrea to return the ping on this one.

> http://userweb.kernel.org/~akpm/mmotm/broken-out/acpi-set-flag-dock_undocking-when-triggered-via-sysfs.patch
> 
>   Fix a system lockup related to undocking.

I'm waiting for Kristen to Ack/Nak that one.

thanks,
-Len


