Return-Path: <linux-kernel-owner+w=401wt.eu-S1756759Ab0A2IKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759Ab0A2IKg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 03:10:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756749Ab0A2IKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 03:10:35 -0500
Received: from buzzloop.caiaq.de ([212.112.241.133]:43696 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756746Ab0A2IKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 03:10:34 -0500
Date: Fri, 29 Jan 2010 09:10:10 +0100
From: Daniel Mack <daniel@caiaq.de>
To: Ramagudi Naziir <naziirr@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: how do YOU hack the linux kernel ?
Message-ID: <20100129081010.GA30756@buzzloop.caiaq.de>
References: <dfb262381001190452k3bad790ax14bbdbe92210b2d3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dfb262381001190452k3bad790ax14bbdbe92210b2d3@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 19, 2010 at 02:52:57PM +0200, Ramagudi Naziir wrote:
> do you use vim ?
> 
> If so, how do you open files you want to read/edit ?
> Assuming you don't remember their exact name/location, you'd need to
> use something like 'find . -iname '*pattern*'. which is slow.
> You can also ":tabnew ." and just browse the folders, but that's super slow too.

Just use ctags to index your tree. Vim can then use this index to
directly drop you at the definition of a symbol. Works very well. Just
google around to find tutorials to describe that in detail.

LXR is also a nice help sometimes: http://lxr.linux.no/linux/

Other than that you might develop a feeling for where to search, so you
can narrow your 'git grep' to specific places.

HTH,
Daniel
