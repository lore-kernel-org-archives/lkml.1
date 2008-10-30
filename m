Return-Path: <linux-kernel-owner+w=401wt.eu-S1758026AbYJ3V3h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758026AbYJ3V3h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 17:29:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753660AbYJ3V33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 17:29:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:58937 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826AbYJ3V32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 17:29:28 -0400
Date: Thu, 30 Oct 2008 14:29:49 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Ravikiran G Thirumalai <kiran@scalex86.org>
Cc: Ingo Molnar <mingo@elte.hu>, venkatesh.pallipadi@intel.com,
       linux-kernel@vger.kernel.org, tim@scalemp.com, shai@scalex86.org
Subject: Re: [patch] x86: Fix /dev/mem mmap breakage when PAT is disabled
Message-ID: <20081030142949.75df90cc@infradead.org>
In-Reply-To: <20081030212121.GB6583@localdomain>
References: <20081030020203.GA12423@localdomain>
	<20081030132103.2daff1e1@infradead.org>
	<20081030212121.GB6583@localdomain>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Oct 2008 14:21:21 -0700
Ravikiran G Thirumalai <kiran@scalex86.org> wrote:

> On Thu, Oct 30, 2008 at 01:21:03PM -0700, Arjan van de Ven wrote:
> >On Wed, 29 Oct 2008 19:02:03 -0700
> >Ravikiran G Thirumalai <kiran@scalex86.org> wrote:
> >
> >well... technically the aliases are bad without PAT as well...
> >
> 
> Hmm! Well, you mean if mtrr is used to change attributes?

you can also set uncached in the pagetables, like via ioremap_uncached
and other ways.

and /dev/mem may or may not imply cached/uncached, depending on the
open flags.

On memory... what would that mean?

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
