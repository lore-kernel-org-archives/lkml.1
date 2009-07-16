Return-Path: <linux-kernel-owner+w=401wt.eu-S1754896AbZGPJ7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896AbZGPJ7o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 05:59:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754780AbZGPJ7n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 05:59:43 -0400
Received: from smtp.nokia.com ([192.100.105.134]:37420 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754753AbZGPJ7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 05:59:42 -0400
Subject: Re: [PATCH 02/06] Fix compilation warning for fs/ubifs/commit.c
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Subrata Modak <subrata@linux.vnet.ibm.com>, linux-mtd@lists.infradead.org,
       Adrian Hunter <adrian.hunter@nokia.com>,
       Sachin P Sant <sachinp@linux.vnet.ibm.com>,
       David Howells <dhowells@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4A5E1D1A.3090705@s5r6.in-berlin.de>
References: <20090715021901.4112.45973.sendpatchset@subratamodak.linux.ibm.com>
	 <1247640750.11353.6.camel@localhost.localdomain>
	 <4A5E1D1A.3090705@s5r6.in-berlin.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 16 Jul 2009 12:57:12 +0300
Message-Id: <1247738232.11353.90.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 16 Jul 2009 09:57:14.0567 (UTC) FILETIME=[CBAF3D70:01CA05FB]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-15 at 20:16 +0200, Stefan Richter wrote:
> Artem Bityutskiy wrote:
> > On Wed, 2009-07-15 at 07:49 +0530, Subrata Modak wrote:
> >> Following fix is inspired by David Howells fix few days back:
> >> http://lkml.org/lkml/2009/7/9/109,
> >>
> >> Signed-off-by: Subrata Modak<subrata@linux.vnet.ibm.com>,
> >> ---
> > 
> > Removed junk comma at the end of "signed-off-by" and pushed to
> > the ubifs-2.6.git tree:
> > 
> > http://git.infradead.org/ubifs-2.6.git?a=commit;h=5c1507e6097c4abc13bbad69de137366c9043f22
> > 
> > Thanks.
> > 
> 
> The changelog of the patch is bad.  "Fix compilation warning" is not 
> correct.  It should be "suppress compilation warning" or "annotate 
> unitialized variable" or whatever --- i.e. it should say what it does.

For me this sounds the same. But probably your version is better
English. I'll change this.

> Furthermore, since the 3 lines context around the change in the diff do 
> not reveal why the chosen "fix" is correct and desirable, the changelog 
> should also leave a note why it's done this way.

The changelog says which kind of warning is fixed, I though it is
obvious what is the warning. At lease for me it would.

But if Subrata sends me the warning he sees, I'll change that.
Thankfully I did not push the patch to ubifs-2.6.git/linux-next
which I never re-base, but pushed it to master which I do rebase
and it is documented here:
http://www.linux-mtd.infradead.org/doc/ubifs.html#L_source

So I may just amend the commit's message.

> The patch form David Howells which is quoted here has an equally bad 
> subject, but at least its changelog goes on to explain what the patch 
> really does and why it does it in the proposed way.

Well, I just thought this type of warnings and way of fixing is very
standard because I saw many similar fixes all over the place.

Anyway, amended the patch like this so far:
http://git.infradead.org/ubifs-2.6.git?a=commit;h=5c1507e6097c4abc13bbad69de137366c9043f22

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

