Return-Path: <linux-kernel-owner+w=401wt.eu-S1757265AbYBDVe5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757265AbYBDVe5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 16:34:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755246AbYBDVee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 16:34:34 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:46125 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754822AbYBDVed (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 16:34:33 -0500
Date: Mon, 4 Feb 2008 13:34:06 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: Oliver Pinter <oliver.pntr@gmail.com>
Cc: stable@kernel.org, linux-kernel@vger.kernel.org,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>, Greg KH <gregkh@suse.de>,
       Willy Tarreau <w@1wt.eu>, Adrian Bunk <bunk@kernel.org>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: {2.6.22.y} CVE-2007-6434
Message-ID: <20080204213406.GX28947@sequoia.sous-sol.org>
References: <6101e8c40802041213y4f3cb310qaff40052ed18d5df@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6101e8c40802041213y4f3cb310qaff40052ed18d5df@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oliver Pinter (oliver.pntr@gmail.com) wrote:
> mainline: ecaf18c15aac8bb9bed7b7aa0e382fe252e275d5
> 
> --->8---
> commit ecaf18c15aac8bb9bed7b7aa0e382fe252e275d5
> Author: Eric Paris <eparis@redhat.com>
> Date:   Tue Dec 4 23:45:31 2007 -0800
> 
>     VM/Security: add security hook to do_brk
> 
>     Given a specifically crafted binary do_brk() can be used to get low pages
>     available in userspace virtual memory and can thus be used to circumvent
>     the mmap_min_addr low memory protection.  Add security checks in do_brk().

All of the low mmap addr stuff isn't added until 2.6.23.

thanks,
-chris
