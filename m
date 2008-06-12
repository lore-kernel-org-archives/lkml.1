Return-Path: <linux-kernel-owner+w=401wt.eu-S1760625AbYFLXW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760625AbYFLXW2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 19:22:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755934AbYFLXWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 19:22:16 -0400
Received: from vs166246.vserver.de ([62.75.166.246]:39490 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753907AbYFLXWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 19:22:15 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] ssb: Fix coherent DMA mask for PCI devices
Date: Fri, 13 Jun 2008 01:21:49 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: "John Linville" <linville@tuxdriver.com>, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       "Kirill A. Shutemov" <kirill@shutemov.name>,
       "Glauber Costa" <gcosta@redhat.com>
References: <200806121533.14435.mb@bu3sch.de> <84144f020806121444i43d381ehdee1774c135d8841@mail.gmail.com>
In-Reply-To: <84144f020806121444i43d381ehdee1774c135d8841@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806130121.50052.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 June 2008 23:44:13 Pekka Enberg wrote:
> On Thu, Jun 12, 2008 at 4:33 PM, Michael Buesch <mb@bu3sch.de> wrote:
> > This fixes setting the coherent DMA mask for PCI devices.
> >
> > Signed-off-by: Michael Buesch <mb@bu3sch.de>
> >
> > ---
> >
> > John, please queue this bugfix for 2.6.26
> >
> > The whole SSB DMA API should be rewritten, as it makes too many bad
> > assumptions about the other subsytems. I will do that soon.
> > But let's apply this patch for now, as it fixes this particular bug.
> 
> Hmm. Does the patch have anything to do with this bug report?
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=10819
> 
> 

Sorry. Magic crystal ball is broken. :)
Can you please try?

-- 
Greetings Michael.
