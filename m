Return-Path: <linux-kernel-owner+w=401wt.eu-S1764867AbYCGBh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764867AbYCGBh2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 20:37:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758184AbYCGBhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 20:37:06 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:58618 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754176AbYCGBhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 20:37:04 -0500
Date: Fri, 07 Mar 2008 10:35:09 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Badari Pulavarty <pbadari@us.ibm.com>
Subject: Re: [PATCH 1/5] generic __remove_pages() support
Cc: Dave Hansen <haveblue@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, paulus@samba.org,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1204839763.6272.8.camel@dyn9047017100.beaverton.ibm.com>
References: <1204836859.4772.32.camel@nimitz.home.sr71.net> <1204839763.6272.8.camel@dyn9047017100.beaverton.ibm.com>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20080307102032.A17D.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.45 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Badari-san.

> On Thu, 2008-03-06 at 12:54 -0800, Dave Hansen wrote:
> > On Thu, 2008-03-06 at 10:55 -0800, Badari Pulavarty wrote:
> > > +               if (memmap)
> > > +                       __kfree_section_memmap(memmap, PAGES_PER_SECTION);
> > > +               return;
> > > +       }
> > > +
> > > +       /*
> > > +        * Allocations came from bootmem - how do I free up ?
> > > +        */
> > > +
> > 
> > Shouldn't we figure this one out before merging?
> > 
> > I think we at least need a printk() there.
> 
> I can add a printk(). I am hoping Yasunori Goto has something to
> handle this, before we really merge into mainline.

Ah, yes. 
I'm making patches for around here. I'm sorry for your waiting.

BTW, do you hurry for merging your patch? 
To be honest, I would like to solve not only here
but also some other issues.
But, if you hurry, I'll concentrate to solve only this.

Bye.

-- 
Yasunori Goto 


