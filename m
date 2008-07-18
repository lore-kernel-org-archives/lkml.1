Return-Path: <linux-kernel-owner+w=401wt.eu-S1759997AbYGRQ7I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759997AbYGRQ7I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 12:59:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756625AbYGRQ64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 12:58:56 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:12375 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755653AbYGRQ64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 12:58:56 -0400
Date: Fri, 18 Jul 2008 18:58:14 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: Jan Beulich <jbeulich@novell.com>, Andi Kleen <andi@firstfloor.org>,
       robert.moore@intel.com, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Endless ACPI errors on Linus tree (5b664cb235)
Message-ID: <20080718165814.GF32051@basil.nowhere.org>
References: <s5hzlof1ll2.wl%tiwai@suse.de> <87od4vqvaj.fsf@basil.nowhere.org> <s5htzencp02.wl%tiwai@suse.de> <s5hr69rz57u.wl%tiwai@suse.de> <s5hk5fjurag.wl%tiwai@suse.de> <4880DE15.76E4.0078.0@novell.com> <s5habgfdu5e.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5habgfdu5e.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 18 Jul 2008 16:58:12.0408 (UTC) FILETIME=[7694AB80:01C8E8F7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2008 at 06:38:53PM +0200, Takashi Iwai wrote:
> At Fri, 18 Jul 2008 17:16:53 +0100,
> Jan Beulich wrote:
> > 
> > >OK, found out the bad commit via bisect.
> > >Reverting below fixes the boot problem.
> > >
> > >
> > >commit 01a5bba576b9364b33f61f0cd9fa70c2cf5535e2
> > >Author: Jan Beulich <jbeulich@novell.com>
> > >Date:   Wed Jul 16 23:27:08 2008 +0200
> > >
> > >    Fix FADT parsing
> >     
> > After someone else observed some problem with this patch earlier, I had
> > already sent out attached patch as a replacement one. Any chance you
> > could also try this with your box?
> 
> It resulted in the same error, unfortunately.

Can you send a acpi table dump please?

-Andi
