Return-Path: <linux-kernel-owner+w=401wt.eu-S937252AbYEUUfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937252AbYEUUfq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 16:35:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764517AbYEUUfh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 16:35:37 -0400
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:1570 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763719AbYEUUfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 16:35:36 -0400
Date: Wed, 21 May 2008 22:35:23 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@localhost.localdomain
To: Miklos Szeredi <miklos@szeredi.hu>
cc: linux-fsdevel@vger.kernel.org, hch@infradead.org, viro@ZenIV.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 06/14] hfsplus: remove hfsplus_permission()
In-Reply-To: <20080521171549.964767446@szeredi.hu>
Message-ID: <Pine.LNX.4.64.0805212232500.18302@localhost.localdomain>
References: <20080521171458.077908538@szeredi.hu> <20080521171549.964767446@szeredi.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 21 May 2008, Miklos Szeredi wrote:

> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> I'm not sure what this function is trying to achieve, but it's not
> succeeding: the condition for which it is returning zero is exactly
> the same as checked by permission(), which results in -EACCES.
> 
> So in the end this is equivalent to the default action.

No, it's not, it allows for HFS+ specific special case to allow the lookup 
of the resource fork.

bye, Roman
