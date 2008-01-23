Return-Path: <linux-kernel-owner+w=401wt.eu-S1752447AbYAWKJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447AbYAWKJ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 05:09:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751302AbYAWKJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 05:09:49 -0500
Received: from one.firstfloor.org ([213.235.205.2]:39624 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141AbYAWKJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 05:09:49 -0500
Date: Wed, 23 Jan 2008 11:43:29 +0100
From: Andi Kleen <andi@firstfloor.org>
To: =?iso-8859-1?Q?Lo=EFc_Greni=E9?= <loic.grenie@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: vmalloc_32 and SLAB incompatible in 2.6.23.9
Message-ID: <20080123104329.GB25136@one.firstfloor.org>
References: <9b06e8d20801230114v1e09e5e8s6a4b438562c62619@mail.gmail.com> <p73wsq0lw9r.fsf@crumb.suse.de> <9b06e8d20801230204t4450191eh996a9d45d3ec32a6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b06e8d20801230204t4450191eh996a9d45d3ec32a6@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>      vmalloc_32 is using __vmalloc. I am much too ignorant to try and change
>   anything in mm/*.[ch]. If vmalloc_32 is incompatible with sl[aou]b, should'nt
>   it be either modified or removed ?

vmalloc does not use sl[aou]b for the data pages. That is why it can
support GFP_DMA32 (or even GFP_DMA if you wanted) 

-Andi
