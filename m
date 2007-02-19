Return-Path: <linux-kernel-owner+w=401wt.eu-S932212AbXBSNEa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932212AbXBSNEa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 08:04:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932211AbXBSNEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 08:04:30 -0500
Received: from smtp.nokia.com ([131.228.20.170]:28957 "EHLO
	mgw-ext11.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932212AbXBSNE3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 08:04:29 -0500
Subject: Re: [PATCH 00/44 take 2] [UBI] Unsorted Block Images
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Theodore Tso <tytso@mit.edu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>
In-Reply-To: <20070217224952.GB16522@thunk.org>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
	 <20070217224952.GB16522@thunk.org>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 19 Feb 2007 14:48:23 +0200
Message-Id: <1171889303.13817.29.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 19 Feb 2007 12:48:22.0848 (UTC) FILETIME=[3D5E1400:01C75424]
X-eXpurgate-Category: 1/0
X-eXpurgate-ID: 149371::070219144503-32398BB0-70737D8A/0-0/0-1
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore,

On Sat, 2007-02-17 at 17:49 -0500, Theodore Tso wrote:
>         This patch introduces the Makefile before any of the source
> files, which means it will break "git bisect" operations.  Could you
> please refactor your patches so that the tree will build after any
> point in your patch series? 

I actually did not mean these patches should be included to a git. We
have UBI git to pull from for these purposes. I basically manually split
the UBI sources to make UBI easier to review. I should have added an
"RFC" tag, apologies.

> 	BTW, I'm not personally found of having a separate .h file for
> every .c file; in my mind a much better division is a public and
> private header file.

This reflects the way of my thinking. I see UBI as a set of units with
defined interfaces. So I even physically split the interface description
into files. I still think it is easier to grasp the architecture this
way.

So, it is not distinct header for _.c_ file, it is a distinct header for
each _unit_, which is a basic architecture element of UBI.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

