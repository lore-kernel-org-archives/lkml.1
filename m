Return-Path: <linux-kernel-owner+w=401wt.eu-S1754803AbYGBQfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803AbYGBQfb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 12:35:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751500AbYGBQfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 12:35:17 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:58691 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbYGBQfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 12:35:16 -0400
Date: Wed, 2 Jul 2008 17:35:10 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Justin Mattock <justinmattock@gmail.com>
Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: dsdt buggy acpi
Message-ID: <20080702163510.GA8912@srcf.ucam.org>
References: <dd18b0c30806302339q7b3effybf8a7f619b009262@mail.gmail.com> <200807011619.53339.rjw@sisk.pl> <dd18b0c30807010918p48cfbe2bnb7e4a2bf00a01638@mail.gmail.com> <20080702082555.0959ef2b@linux360.ro> <20080702100935.GA699@srcf.ucam.org> <20080702144820.29f7d43d@linux360.ro> <20080702115527.GA3396@srcf.ucam.org> <dd18b0c30807020930u43405fd5v2e328b6b76b833b0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd18b0c30807020930u43405fd5v2e328b6b76b833b0@mail.gmail.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2008 at 04:30:11PM +0000, Justin Mattock wrote:

> Hello; what info is supplied with EFI i.g. I'm using a macbook pro.
> After looking at:
> http://acpi.sourceforge.net/dsdt/view.php I was unable to locate
> anything with apple, or at least
> couldn't find the manufacture number.
> If somebody has already done this, I was wondering if it would be O.K.
> if I can attached my dsdt.dsl with the errors,
> and my explanation of what I changed, just so If I did something
> completely wrong

iasl will complain about code that the Linux interpreter will happily 
accept. If the only reason you've made changes is that iasl complains, 
then it's unlikely that there's any functional difference as a result. 
Otherwise, work out which changes fix which Linux bugs and file a bug 
at bugzilla.kernel.org against acpi.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
