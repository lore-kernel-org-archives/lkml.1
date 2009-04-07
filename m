Return-Path: <linux-kernel-owner+w=401wt.eu-S1759545AbZDGR4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759545AbZDGR4e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 13:56:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758195AbZDGR4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 13:56:21 -0400
Received: from mail2.shareable.org ([80.68.89.115]:58887 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757933AbZDGR4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 13:56:20 -0400
Date: Tue, 7 Apr 2009 18:56:17 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Oleg Drokin <green@linuxhacker.ru>, linux-fsdevel@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Attempt at "stat light" implementation
Message-ID: <20090407175617.GF31824@shareable.org>
References: <20090407062356.GA1336463@fiona.linuxhacker.ru> <20090407173248.GC31824@shareable.org> <49DB8F8E.9010605@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49DB8F8E.9010605@garzik.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Jamie Lokier wrote:
> >Once you have fine-grained selection of stat fields - it's natural to
> >ask why not allow _additional_ stat fields in an future-extensible
> >fashion?  A few things would be handy sometimes, such as inode
> >generation number, modification generation number (to detect changes
> >across reboots), and extra flags indicating COW or other properties.
> 
> That's quite an interesting thought...  until you run out of flags, the 
> stat structure becomes a bit more flexible.

I suspect at least one other unix or unix-like OS has done this
already, and it might be worth copying the interface.  But none come to
mind.

(I'm not counting DJGPP on MS-DOS ;-)

-- Jamie
