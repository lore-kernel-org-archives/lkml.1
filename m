Return-Path: <linux-kernel-owner+w=401wt.eu-S1760136AbYECCwN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760136AbYECCwN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 22:52:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756874AbYECCwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 22:52:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50848 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756864AbYECCv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 22:51:59 -0400
Date: Fri, 2 May 2008 19:51:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
       linux-kernel@vger.kernel.org, joern@lazybastard.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: [PATCH] fix checkstack.pl arch detection
Message-Id: <20080502195118.39a3fc99.akpm@linux-foundation.org>
In-Reply-To: <481BD097.9010201@redhat.com>
References: <481B4D75.9060305@redhat.com>
	<20080502223702.GI24080@logfs.org>
	<20080502164458.b703acf7.akpm@linux-foundation.org>
	<481BCC00.1030508@redhat.com>
	<20080502193128.5e1de100.akpm@linux-foundation.org>
	<481BD097.9010201@redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 02 May 2008 21:40:23 -0500 Eric Sandeen <sandeen@redhat.com> wrote:

> Andrew Morton wrote:
> 
> >>> please cc apw on checkpatch changes.
> >>>
> >>> This patch needs some help to merge against the forthcoming
> >>> checkpatch-0.19.  I sent your patches apw-wards.
> >>>
> >> Um, checkpatch or checkstack? :)
> >>
> > 
> > bah.
> > 
> > hm, I wonder why one of them got a reject.  `patch -l' was needed.  Mailer
> > munchies, perhaps?
> > 
> > Please check that what I applied is still correct.
> 
> They look fine... sorry, didn't generate against -mm but didn't expect
> differences.  I'll update an -mm tree and give it a functional check too...
> 

There are no changes since 2.6.25.

"find dynamic stack allocations in checkstack.pl" just doesn't apply.  Hunk
1 assumes that "fix checkstack.pl arch detection" is present, but when "fix
checkstack.pl arch detection" is applied, hunks 1 and 2 don't apply.

