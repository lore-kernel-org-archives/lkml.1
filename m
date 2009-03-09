Return-Path: <linux-kernel-owner+w=401wt.eu-S1754375AbZCIQ6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754375AbZCIQ6U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 12:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752306AbZCIQ6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 12:58:11 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:41953 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791AbZCIQ6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 12:58:10 -0400
Date: Mon, 9 Mar 2009 10:58:07 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Alex Chiang <achiang@hp.com>, Greg KH <greg@kroah.com>,
       kay.sievers@vrfy.org, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: kobj refcounting weirdness
Message-ID: <20090309165807.GU25995@parisc-linux.org>
References: <20090309063654.GB23137@ldl.fc.hp.com> <20090309150453.GB7627@kroah.com> <20090309165010.GB32589@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090309165010.GB32589@ldl.fc.hp.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 09, 2009 at 10:50:10AM -0600, Alex Chiang wrote:
> I thought about the allocators returning a pointer to the same
> location that maybe has some valid looking data hanging around,
> but it's not wise for someone like me to go pointing fingers at
> the allocator before I've proven the bug isn't in my code. ;)

Slab poisoning would be the logical next thing to try to decide whether
the allocator is wrong or you're using it wrong ;-)

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
