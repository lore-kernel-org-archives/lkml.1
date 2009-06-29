Return-Path: <linux-kernel-owner+w=401wt.eu-S1756660AbZF2Ugb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756660AbZF2Ugb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 16:36:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752776AbZF2UgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 16:36:23 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43353 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbZF2UgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 16:36:22 -0400
Date: Mon, 29 Jun 2009 22:36:19 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
       npiggin@suse.de, chris.mason@oracle.com, kurt.hackel@oracle.com,
       dave.mccracken@oracle.com, Avi Kivity <avi@redhat.com>, jeremy@goop.org,
       Rik van Riel <riel@redhat.com>, alan@lxorguk.ukuu.org.uk,
       Rusty Russell <rusty@rustcorp.com.au>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>, akpm@osdl.org,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, tmem-devel@oss.oracle.com,
       sunil.mushran@oracle.com, linux-mm@kvack.org,
       Himanshu Raj <rhim@microsoft.com>
Subject: Re: [RFC] transcendent memory for Linux
Message-ID: <20090629203619.GA6611@elf.ucw.cz>
References: <20090624150420.GH1784@ucw.cz> <0dbec206-c157-4482-8fd7-4ccf9c2bdc5a@default>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0dbec206-c157-4482-8fd7-4ccf9c2bdc5a@default>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> It is documented currently at:
> 
> http://oss.oracle.com/projects/tmem/documentation/api/
> 
> (just noticed I still haven't posted version 0.0.2 which
> has a few minor changes).
> 
> I will add a briefer description of this API in Documentation/

Please do.

At least TMEM_NEW_POOL() looks quite ugly. Why uuid? Mixing flags into
size argument is strange.

> It is in-kernel only because some of the operations have
> a parameter that is a physical page frame number.

In-kernel API is probably better described as function prototypes.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
