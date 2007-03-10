Return-Path: <linux-kernel-owner+w=401wt.eu-S933464AbXCJPeb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933464AbXCJPeb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 10:34:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161041AbXCJPeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 10:34:31 -0500
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:1188 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933464AbXCJPea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 10:34:30 -0500
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Jiri Kosina <jkosina@suse.cz>
Subject: Re: 2.6.21-rc3-mm1
Date: Sat, 10 Mar 2007 16:36:47 +0100
User-Agent: KMail/1.9.5
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
References: <20070307201839.6f45735b.akpm@linux-foundation.org> <20070310091820.GB30495@kroah.com> <Pine.LNX.4.64.0703101337460.10121@jikos.suse.cz>
In-Reply-To: <Pine.LNX.4.64.0703101337460.10121@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703101636.48758.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> On Sat, 10 Mar 2007, Greg KH wrote:
> 
> > > hid_parse_report() is doing kmalloc(128k kbytes).  We canot sanely 
> > > support that and the code shold be rewritten to not do that.  A simple 
> > > though somewhat lame fix would be to switch to vmalloc().
> > > It's been this way for some time, so it's odd that the failures have 
> > > just popped up now.
> > Jiri is the person to ask about this now.  Jiri, any thoughts about
> > this?
> 
> I have just queued the patch below to HID tree for the next upstream 
> merge. Mariusz, I guess it solves your issue, right?

Right. Can't be 100% sure but without the patch it would have probably
failed by now so I guess the patch is ok. Not sure how to make usb mouse
plugging/unplugging process automatic ;-)

Thanks,

	Mariusz Kozlowski
