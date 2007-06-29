Return-Path: <linux-kernel-owner+w=401wt.eu-S932301AbXF2Mh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932301AbXF2Mh3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 08:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755429AbXF2MhW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 08:37:22 -0400
Received: from gw.goop.org ([64.81.55.164]:41244 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752771AbXF2MhV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 08:37:21 -0400
Message-ID: <4684FCC9.7010709@goop.org>
Date: Fri, 29 Jun 2007 08:36:25 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Dave Young <hidave.darkstar@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ioremap: fix iounmap numpages
References: <20070629170907.GA1735@darkstar.te-china.tietoenator.com>
In-Reply-To: <20070629170907.GA1735@darkstar.te-china.tietoenator.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Young wrote:
> Hi,
> The second parameter of change_page_attr in iounmap is wrong, it should be (p->size - 1) >> PAGE_SHIFT
>   

Why's that?  Isn't p->size always going to be a pagesize multiple; in 
which case, why would you want to change_page_attr on n-1 pages?

Are you seeing a problem that this patch fixes?

    J
