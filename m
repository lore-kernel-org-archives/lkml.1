Return-Path: <linux-kernel-owner+w=401wt.eu-S1764581AbXGKVqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764581AbXGKVqU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 17:46:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751772AbXGKVqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 17:46:07 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54770 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755676AbXGKVqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 17:46:06 -0400
Date: Wed, 11 Jul 2007 14:45:51 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Roland McGrath <roland@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] Add /sys/kernel/notes
In-Reply-To: <20070711205120.396CD4D0555@magilla.localdomain>
Message-ID: <alpine.LFD.0.999.0707111443180.20061@woody.linux-foundation.org>
References: <20070711205120.396CD4D0555@magilla.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 11 Jul 2007, Roland McGrath wrote:
> 
> It hadn't really occurred to me that the kernel binary would be
> deliberately hidden from the user.

We don't want to have things like config info, or really preferably 
anything that can be used to generate kernel addresses.

Yeah, we've made that mistake before, and I'm not saying we are perfect 
here, but if we make this world-readable, I think it needs to guarantee it 
doesn't really give any rootkit people any new information.

And yes, I do think normal people shouldn't be able to read the vmlinuz 
binary, the same way they are generally not allowed to read /etc/grub.conf 
etc.

			Linus
