Return-Path: <linux-kernel-owner+w=401wt.eu-S1756654AbXFNT7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654AbXFNT7Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 15:59:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752926AbXFNT7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 15:59:17 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36214 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751448AbXFNT7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 15:59:16 -0400
Date: Thu, 14 Jun 2007 12:56:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, johannes@sipsolutions.net,
       linux-wireless@vger.kernel.org, dcbw@redhat.com,
       hs4233@mail.mn-solutions.de, linux-kernel@vger.kernel.org,
       marcelo@kvack.org
Subject: Re: libertas (private) ioctls vs. nl80211
Message-Id: <20070614125618.a7338ad8.akpm@linux-foundation.org>
In-Reply-To: <20070614190936.GA28917@tuxdriver.com>
References: <1181757483.29767.99.camel@johannes.berg>
	<20070614170901.GA13384@infradead.org>
	<20070614103836.23b07a72.akpm@linux-foundation.org>
	<20070614181307.GA16856@infradead.org>
	<alpine.LFD.0.98.0706141121080.14121@woody.linux-foundation.org>
	<20070614190936.GA28917@tuxdriver.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jun 2007 15:09:36 -0400
"John W. Linville" <linville@tuxdriver.com> wrote:

> It does not make sense to me to rip this out purely for aesthetic
> reasons.

Aesthetics are good, but that's not the main issue.

What is most worrying is that there appears to be a risk that these
newly-added interfaces will later become obsoleted by another interface. 
This means that we'll need to maintain, test and support _both_ interfaces
for a very long time.  This is the sort of foot-shooting we should avoid.

