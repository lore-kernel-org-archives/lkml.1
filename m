Return-Path: <linux-kernel-owner+w=401wt.eu-S1759715AbYCCDVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759715AbYCCDVR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 22:21:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751550AbYCCDVB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 22:21:01 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:41014 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753245AbYCCDVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 22:21:00 -0500
Date: Mon, 03 Mar 2008 12:21:27 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Rick van Rein <rick@vanrein.org>
Subject: Re: [PATCH 2.6.24] mm: BadRAM support for broken memory
Cc: kosaki.motohiro@jp.fujitsu.com, KOSAKI Motohiro <m-kosaki@ceres.dti.ne.jp>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080302174235.GA26902@phantom.vanrein.org>
References: <2f11576a0803020901n715fda8esbfc0172f5a15ae3c@mail.gmail.com> <20080302174235.GA26902@phantom.vanrein.org>
Message-Id: <20080303121335.1E7B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rick

> > >  +#define PG_badram              20      /* BadRam page */
> > 
> > some architecture use PG_reserved for treat bad memory.
> > Why do you want introduce new page flag?
> 
> It is clearer to properly name a flag, I suppose.
> Is the use that you are mentioning the intended, and only use of the flag?
> If not, I think it is clearer to use a separate flag instead of overloading
> one.

hmmm
unfortunately flag bit of struct page is very valuable resource
rather than diamond on current implementaion ;-)

if you can change to no introduce new page flag,
IMHO merge to mainline dramatically become easy.


> > for show_mem() improvement?
> 
> For code clarity.

agreed with your code is clarify. but...



