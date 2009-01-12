Return-Path: <linux-kernel-owner+w=401wt.eu-S1757310AbZALU1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757310AbZALU1k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 15:27:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753511AbZALU12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 15:27:28 -0500
Received: from tservice.net.ru ([195.178.208.66]:60693 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753279AbZALU11 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 15:27:27 -0500
Date: Mon, 12 Jan 2009 23:27:26 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: =?utf-8?B?UsOpbWk=?= Denis-Courmont <rdenis@simphalempin.com>
Cc: Andi Kleen <andi@firstfloor.org>, Valdis.Kletnieks@vt.edu,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Michael Stone <michael@laptop.org>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: RFC: Network privilege separation.
Message-ID: <20090112202726.GA2169@ioremap.net>
References: <1231307334-9542-1-git-send-email-michael@laptop.org> <200901122147.57731.rdenis@simphalempin.com> <20090112201435.GC23848@one.firstfloor.org> <200901122215.27842.rdenis@simphalempin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200901122215.27842.rdenis@simphalempin.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 10:15:27PM +0200, Rémi Denis-Courmont (rdenis@simphalempin.com) wrote:
> > I don't think that's given. It would need some restructuring,
> > but I think the end result would be likely worth it.
> 
> A normal DVD would be over 30 megabytes per seconds once decoded, just for the 
> video. And remember vmsplice() is not allowed by SECCOMP. Media players have 
> assembly-coded memory copy optimizations (like the kernel) for some reason.

Just a note: memory copy is way too faster than 30 mb/s, and very likely
it is not the memory copy, but (de)compression, since likely all modern
codecs are limited by the CPU and not the memory bandwidth.

-- 
	Evgeniy Polyakov
