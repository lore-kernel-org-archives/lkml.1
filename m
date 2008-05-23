Return-Path: <linux-kernel-owner+w=401wt.eu-S1756090AbYEWSeM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090AbYEWSeM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 14:34:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754589AbYEWSdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 14:33:55 -0400
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:1552 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753774AbYEWSdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 14:33:54 -0400
Date: Fri, 23 May 2008 20:33:30 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@localhost.localdomain
To: Miklos Szeredi <miklos@szeredi.hu>
cc: hch@infradead.org, linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 06/14] hfsplus: remove hfsplus_permission()
In-Reply-To: <E1Jzbai-0002d1-VC@pomaz-ex.szeredi.hu>
Message-ID: <Pine.LNX.4.64.0805232027220.18302@localhost.localdomain>
References: <20080521171458.077908538@szeredi.hu> <20080521171549.964767446@szeredi.hu>
 <Pine.LNX.4.64.0805212232500.18302@localhost.localdomain>
 <E1Jz5gq-0007F4-AQ@pomaz-ex.szeredi.hu> <Pine.LNX.4.64.0805221358080.18302@localhost.localdomain>
 <E1Jz9jk-0007rg-5W@pomaz-ex.szeredi.hu> <Pine.LNX.4.64.0805221427300.18302@localhost.localdomain>
 <E1JzA2r-0007uK-8L@pomaz-ex.szeredi.hu> <20080523092114.GD27119@infradead.org>
 <Pine.LNX.4.64.0805231712120.18302@localhost.localdomain>
 <E1JzZF5-0002Hz-5e@pomaz-ex.szeredi.hu> <E1JzZWC-0002M8-UP@pomaz-ex.szeredi.hu>
 <Pine.LNX.4.64.0805231824370.18302@localhost.localdomain>
 <E1Jzbai-0002d1-VC@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 23 May 2008, Miklos Szeredi wrote:

>  a) it's nontrivial to fix (even understanding the problem is
>  nontrivial, see Documentation/filesystems/directory-locking)

Please provide a concrete example, as long as I only get handwaving I can 
only wave back.

>  b) the feature is obviously unused, so the easiest fix is simply to
>  remove it for the time being.

You have a weird definition of "obviously unused", not every user may even 
have noticed it's gone, e.g. there are some rsync versions, which support 
this and these won't complain if they can't open the resource fork.

bye, Roman
