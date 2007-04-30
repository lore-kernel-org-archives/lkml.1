Return-Path: <linux-kernel-owner+w=401wt.eu-S1946867AbXD3Wu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946867AbXD3Wu5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 18:50:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946870AbXD3Wu5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 18:50:57 -0400
Received: from gw.goop.org ([64.81.55.164]:56628 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946867AbXD3Wu4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 18:50:56 -0400
Message-ID: <463672DE.90608@goop.org>
Date: Mon, 30 Apr 2007 15:51:10 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, Jeff Garzik <jeff@garzik.org>,
       Andi Kleen <ak@suse.de>, patches@x86-64.org,
       Vivek Goyal <vgoyal@in.ibm.com>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Rusty Russell <rusty@rustcorp.com.au>,
       virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [patches] [PATCH] [21/22] x86_64: Extend bzImage protocol for
 relocatable bzImage
References: <20070428758.455116000@suse.de>	<20070428175909.1D09D151CA@wotan.suse.de> <46338D72.70402@garzik.org>	<m1fy6kdzi1.fsf@ebiederm.dsl.xmission.com> <4634483E.9030307@goop.org>	<m14pmz8bbb.fsf@ebiederm.dsl.xmission.com> <46363A68.6080201@goop.org> <m18xc9344o.fsf@ebiederm.dsl.xmission.com> <463670D1.3000003@goop.org>
In-Reply-To: <463670D1.3000003@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> I haven't checked if it already has this, but it would be nice if the
> bzImage had a memory range/list of memory ranges it needs mapped to get
> the kernel on its feet, so that the domain builder can just go and map
> those areas for it (either P==V mappings, or with a constant offset;
> whichever is more useful).
>   

Of course if it were a properly formed ELF file, you could encode this
in the PHDRs.

    J
