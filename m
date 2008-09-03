Return-Path: <linux-kernel-owner+w=401wt.eu-S1754270AbYICKOv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270AbYICKOv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 06:14:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751771AbYICKOl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 06:14:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:47511 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664AbYICKOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 06:14:40 -0400
Subject: Re: [PATCH] UBIFS: fill f_fsid
From: David Woodhouse <dwmw2@infradead.org>
To: dedekind@infradead.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Adrian Hunter <ext-adrian.hunter@nokia.com>
In-Reply-To: <1220435073.4036.41.camel@sauron>
References: <1220194366-12731-1-git-send-email-dedekind@infradead.org>
	 <1220194366-12731-13-git-send-email-dedekind@infradead.org>
	 <1220262187.2982.58.camel@pmac.infradead.org>
	 <1220435073.4036.41.camel@sauron>
Content-Type: text/plain
Date: Wed, 03 Sep 2008 11:14:36 +0100
Message-Id: <1220436876.2985.82.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-09-03 at 12:44 +0300, Artem Bityutskiy wrote:
> On Mon, 2008-09-01 at 10:43 +0100, David Woodhouse wrote:
> > For btrfs I xor the first 64 bits with the second 64 bits, and put
> > _that_ into f_fsid. You're just putting the first 64 bits in and
> > ignoring the second 64 bits. Neither is really _better_ than the
> other;
> > you just alter the circumstances in which you get collisions. But I
> > suppose we might as well be consistent about how we do it?
>
> Like this?

Yeah, that's what ext[234] and btrfs do.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



