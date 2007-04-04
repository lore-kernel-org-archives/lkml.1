Return-Path: <linux-kernel-owner+w=401wt.eu-S933620AbXDDPqD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933620AbXDDPqD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 11:46:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933566AbXDDPqB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 11:46:01 -0400
Received: from gw.goop.org ([64.81.55.164]:59897 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933620AbXDDPqB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 11:46:01 -0400
Message-ID: <4613C828.2030604@goop.org>
Date: Wed, 04 Apr 2007 08:45:44 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 04/17] Add pagetable accessors to pack and unpack pagetable
 entries
References: <20070402055652.610711908@goop.org> <200704020812.18320.ak@suse.de> <46136F25.7030907@goop.org> <200704041347.42822.ak@suse.de>
In-Reply-To: <200704041347.42822.ak@suse.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Why is there a difference for null syscall? I had assumed we patched all the 
> fast path cases relevant there. Do you have an idea where it comes from?

Sure.  There's indirect calls for things like sti/cli/iret.  It goes
back to native speed when you patch the real instructions inline.

    J
