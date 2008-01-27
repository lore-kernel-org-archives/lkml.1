Return-Path: <linux-kernel-owner+w=401wt.eu-S1756047AbYA0GBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047AbYA0GBp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 01:01:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752189AbYA0GBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 01:01:13 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34247 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751006AbYA0GBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 01:01:11 -0500
Date: Sat, 26 Jan 2008 22:00:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Len Brown <lenb@kernel.org>
Cc: mjg59@srcf.ucam.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH] Rationalise ACPI backlight implementation
Message-Id: <20080126220045.b93db7c9.akpm@linux-foundation.org>
In-Reply-To: <200801241644.49114.lenb@kernel.org>
References: <20071226020325.GA21099@srcf.ucam.org>
	<200801241644.49114.lenb@kernel.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 24 Jan 2008 16:44:48 -0500 Len Brown <lenb@kernel.org> wrote:
> On Tuesday 25 December 2007 21:03, Matthew Garrett wrote:
> > The sysfs backlight class provides no mechanism for querying the 
> > acceptable brightness for a backlight. The ACPI spec states that values 
> > are only valid if they are reported as available by the firmware. Since 
> > we can't provide that information to userspace, instead collapse the 
> > range to the number of actual values that can be set.
> > 
> > Signed-off-by: Matthew Garrett <mjg59@srcf.ucam.org>
> 
> I wish we did this in the first place.
> But doing it now is an API change -- since
> with the old way 100 always meant 100% brightness, yes?
> 
> so my concern is that if we change what "10" means, somebody like akpm
> with an existing script gets grumpy.

It takes more than that to make me grumpy.  I've been very grumpy lately.

- Create a new /sys node with a new name which has the new semantics.

- Deprecate the old /sys entry by emitting an angry printk when someone
  uses it.

- Wait 12 months

- Kill the old one.

