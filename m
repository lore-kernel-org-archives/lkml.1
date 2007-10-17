Return-Path: <linux-kernel-owner+w=401wt.eu-S1760426AbXJQE2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760426AbXJQE2Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 00:28:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751387AbXJQE2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 00:28:00 -0400
Received: from hu-out-0506.google.com ([72.14.214.239]:23848 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbXJQE16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 00:27:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=nRoXQYSB9U/P6MP26RlCo69MNorhlFYmQ9+njD4c5fB/R8zzl4xXqTaD4cqfX3oWb4/VVRmV54gclW+uTRVKVaV76mDY2CuClwKu63z4CP8nV0yg/YZbrjlMKP+s0YezB2RyqckiXNZiiUrOb5iDmazBBBCZ5vI6dgXG4iGM7cU=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Fix to "All wake-up devices are disabled after suspend-to disk" isn't yet included in mainline
Date: Wed, 17 Oct 2007 06:27:26 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>,
       linux-acpi@vger.kernel.org
References: <200710170439.30359.maximlevitsky@gmail.com> <20071016204802.9036ad96.akpm@linux-foundation.org>
In-Reply-To: <20071016204802.9036ad96.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710170627.26136.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 October 2007 05:48:02 Andrew Morton wrote:
> On Wed, 17 Oct 2007 04:39:30 +0200 Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> 
> > A while ago I asked on LKML about the problem of loosing all wake device capabilities, after a suspend to disk
> > (eg: I can't wake the system from keyboard if I suspend to disk and then to ram)
> > 
> > I was provided with the patch that fixes this problem completely.
> > The merge window is open, but I still don't see it in the kernel.
> > Due to changes it doesn't anymore apply to latest git.
> > 
> > Was it missed?
> 
> No, it's in Len's git tree.
> 
> Len's git-pull request from a few days ago didn't work, perhaps because I
> wanted to know if a recent -mm regression had been fixed and that hasn't
> been answered yet.  I assume that Len is offline.  Other acpi developers
> could presumably have answered that question but for some reason chose not to.
> 
> I'm presently holding off 20-odd power management patches due to their
> dependency upon an acpi merge...
> 


Thanks a lot.
	Best regards,
		Maxim Levitsky
