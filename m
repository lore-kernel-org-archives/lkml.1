Return-Path: <linux-kernel-owner+w=401wt.eu-S1761399AbZLJSSH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761399AbZLJSSH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 13:18:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761285AbZLJSSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 13:18:05 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56947 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758514AbZLJSSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 13:18:03 -0500
Date: Thu, 10 Dec 2009 19:18:00 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Alexey Starikovskiy <aystarik@gmail.com>
Cc: Xiaotian Feng <dfeng@redhat.com>, lenb@kernel.org, ming.m.lin@intel.com,
       robert.moore@intel.com, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPICA: don't cond_resched() when irq_disabled or
 in_atomic
Message-ID: <20091210181800.GM19454@elf.ucw.cz>
References: <1259900760-6424-1-git-send-email-dfeng@redhat.com>
 <20091210100907.GA2446@ucw.cz>
 <4B2136D5.1030402@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B2136D5.1030402@gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-12-10 20:58:45, Alexey Starikovskiy wrote:
> Hi Pavel,
> 
> Please elaborate... Your comments "ugly as hell" are too often to be
> specific...
> There is only one use of ACPI_PREEMPTION_POINT(), and it is in the
> ACPICA code,
> which we all agreed to keep OS independent, thus the need for #define.
> Do you see any other way to add preemption point without introducing
> Linux-specific
> code into ACPICA?

I believe we want linux-specific code in acpica at this point.

(Or maybe... I guess other systems have concept of preemption and not
all actions are permitted from all contexts, so maybe something like
that would be important for them, too?)
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
