Return-Path: <linux-kernel-owner+w=401wt.eu-S932203AbZJGHcM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932203AbZJGHcM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 03:32:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758720AbZJGHcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 03:32:10 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51047 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758698AbZJGHcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 03:32:08 -0400
Date: Wed, 7 Oct 2009 09:31:21 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Tippett, Matthew" <matthew.tippett@amd.com>
Cc: Willy Tarreau <w@1wt.eu>, Matthew Garrett <mjg59@srcf.ucam.org>,
       "Langsdorf, Mark" <mark.langsdorf@amd.com>, lenb@kernel.org,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Li, Samuel" <Samuel.Li@amd.com>
Subject: Re: [PATCH][ACPI] AC/DC notifier
Message-ID: <20091007073121.GA31245@elf.ucw.cz>
References: <FFAE0590FF35E441901B67BD8BA62E950245ABD9@storexmb3.amd.com> <20090812005532.GA31003@srcf.ucam.org> <20090814163233.GC1626@ucw.cz> <20090816074008.GA11624@1wt.eu> <4ACB59E2.3000600@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ACB59E2.3000600@amd.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-10-06 10:53:22, Tippett, Matthew wrote:
> (Resending as text-only - sorry)
>
> Bringing this item back up again.
>
> I am not suggesting that the application of any particular policy  
> appears within the kernel or userspace or a secondary policy engine.    
> In general I am also against codifying policy within drivers.
>
> I am interested seeing the ACPI notifier mechanism expanded to allow  
> AC/DC state changes propagate to other kernel drivers without requiring  
> a userspace in between.
>
> I can continue to come up with real scenarios that would possibly  
> require kernel-to-kernel notification, but would rather focus this  
> discussion of the pure technical issues associated with adding the  
> notifier to the AC/DC ACPI subsystem. 

Please do. So far you did not show valid use for such notifier.

(Ok, I know of one. Old amd64 notebooks had cpufreq scaling enabled,
with battery unable to supply enough current to feed the CPU at
highest cpufreq setting. At that point, scaling cpufreq down at unplug
is correctness issue, and AC/DC notifier in kernel makes
sense.)

So... what do you want to use it for?
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
