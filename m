Return-Path: <linux-kernel-owner+w=401wt.eu-S1757534AbYGDNLZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757534AbYGDNLZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 09:11:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753445AbYGDNLN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 09:11:13 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54823 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277AbYGDNLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 09:11:12 -0400
Subject: Re: [bug?] tg3: Failed to load firmware "tigon/tg3_tso.bin"
From: David Woodhouse <dwmw2@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: David Miller <davem@davemloft.net>, tytso@mit.edu, jeff@garzik.org,
       hugh@veritas.com, akpm@linux-foundation.org,
       kosaki.motohiro@jp.fujitsu.com, mchan@broadcom.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       netdev@vger.kernel.org
In-Reply-To: <87ej6armez.fsf@basil.nowhere.org>
References: <1215093175.10393.567.camel@pmac.infradead.org>
	 <20080703173040.GB30506@mit.edu>
	 <1215111362.10393.651.camel@pmac.infradead.org>
	 <20080703.162120.206258339.davem@davemloft.net>
	 <486D6DDB.4010205@infradead.org>  <87ej6armez.fsf@basil.nowhere.org>
Content-Type: text/plain
Date: Fri, 04 Jul 2008 14:10:44 +0100
Message-Id: <1215177044.10393.743.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-07-04 at 12:09 +0200, Andi Kleen wrote:
> David Woodhouse <dwmw2@infradead.org> writes:
> >
> > I'll look at making the requirement for 'make firmware_install' more
> > obvious, or even making it happen automatically as part of
> > 'modules_install'.
> 
> Perhaps I didn't pay enough attention, but how are "only 
> boot bzImage without initrd or modules" setups supposed to work now
> for those drivers? My testing setup relies on that heavily.

That will continue to work just fine.

> Will the firmware automatically end up in initramfs and be included
> in the bzImage and loaded at the right point?

No, not even in the initramfs. It's built _right_ into the static kernel
image, and request_firmware() finds it there without even having to call
out to userspace at all.
http://git.infradead.org/users/dwmw2/firmware-2.6.git?a=commitdiff;h=81d4e79a

-- 
dwmw2

