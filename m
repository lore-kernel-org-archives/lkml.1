Return-Path: <linux-kernel-owner+w=401wt.eu-S1764122AbYBOKry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764122AbYBOKry (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 05:47:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933489AbYBOKrn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 05:47:43 -0500
Received: from mx1.suse.de ([195.135.220.2]:50187 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933472AbYBOKrl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 05:47:41 -0500
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alexey Dobriyan <adobriyan@openvz.org>
Subject: Re: [PATCH] Make sysctl a separate filesystem
From: Andi Kleen <andi@firstfloor.org>
References: <47B56BF2.4020600@openvz.org>
Date: Fri, 15 Feb 2008 11:47:39 +0100
In-Reply-To: <47B56BF2.4020600@openvz.org> (Pavel Emelyanov's message of "Fri\, 15 Feb 2008 13\:39\:46 +0300")
Message-ID: <p73ejbe1ook.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Emelyanov <xemul@openvz.org> writes:
>    this subdir;
> 3. sysctl inodes are now smaller than the procfs ones.

That's always a good thing.

> Note: update your initscripts to mount sysctl filesystem 
> right after the proc is mounted in order not to lose your
> /etc/sysctl.conf configuration (and optionally fstab).

That will break about everybody's init scripts I suspect.

I think you would need to go through some deprecation
period for this at least, with printks warning people
to fix their init scripts.

Or better find some way to do the mount automatically.

-Andi
