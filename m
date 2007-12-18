Return-Path: <linux-kernel-owner+w=401wt.eu-S1751758AbXLRU2G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751758AbXLRU2G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 15:28:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752297AbXLRU1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 15:27:52 -0500
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:35073 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162AbXLRU1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 15:27:51 -0500
X-Greylist: delayed 569 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Dec 2007 15:27:51 EST
Date: Tue, 18 Dec 2007 22:18:10 +0200 (EET)
From: Kai Makisara <Kai.Makisara@kolumbus.fi>
X-X-Sender: makisara@kai.makisara.local
To: James Bottomley <James.Bottomley@SteelEye.com>
cc: Andrew Morton <akpm@linux-foundation.org>, John Stoffel <john@stoffel.org>,
       fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: 2.6.24-rc5: tape drive not responding
In-Reply-To: <1197928348.3204.14.camel@localhost.localdomain>
Message-ID: <alpine.LSU.0.999999.0712182207570.5289@kai.makisara.local>
References: <18277.52079.718004.969358@stoffel.org>  <20071217112551H.fujita.tomonori@lab.ntt.co.jp>  <20071217031510.c3d500fd.akpm@linux-foundation.org>  <18278.55130.471797.398922@stoffel.org>  <18278.58314.892734.490418@stoffel.org> 
 <20071217134344.3f024461.akpm@linux-foundation.org> <1197928348.3204.14.camel@localhost.localdomain>
User-Agent: Alpine 0.999999 (LSU 847 2007-12-06)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Antivirus: VAMS
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Dec 2007, James Bottomley wrote:

> 
> On Mon, 2007-12-17 at 13:43 -0800, Andrew Morton wrote:
> > On Mon, 17 Dec 2007 16:02:02 -0500
> > "John Stoffel" <john@stoffel.org> wrote:
> > 
> > > 
> > > Just to confirm, the propsed patch to st.c fixes the issue with
> > > 2.6.24-rc5 as well at 2.6.24-rc5-mm1 with access to my DLT tape
> > > drives.
> > 
> > err, what patch to st.c?
> 
> That's this one:
> 
> http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commit;h=acdd0b1c371b2fbb4b6110a51ba69cb0af9e6f45
> 
I have done some tests. Firstly, I did not see the BUG with 2.6.24-rc5. 
Looking at include/linux/scatterlist.h suggested that CONFIG_DEBUG_SG has 
something to do with this. When enabled SG debugging, I also saw the BUG. 
Adding this patch solved the problem.

You can add

Acked-by: Kai Makisara <Kai.Makisara@kolumbus.fi>

if you want. This fix should be included in 2.6.24.

-- 
Kai
