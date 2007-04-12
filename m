Return-Path: <linux-kernel-owner+w=401wt.eu-S965564AbXDLQsr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965564AbXDLQsr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 12:48:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965552AbXDLQsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 12:48:41 -0400
Received: from smtp.osdl.org ([65.172.181.24]:48907 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965558AbXDLQsF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 12:48:05 -0400
Date: Thu, 12 Apr 2007 09:47:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Helge Hafting <helge.hafting@aitel.hist.no>
Cc: Jiri Kosina <jikos@jikos.cz>, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: 2.6.21-rc6-mm1 USB related boot hang
Message-Id: <20070412094747.e2b46b7a.akpm@linux-foundation.org>
In-Reply-To: <461E1B41.90000@aitel.hist.no>
References: <20070408143559.f5014629.akpm@linux-foundation.org>
	<20070411194227.GA31286@aitel.hist.no>
	<20070411134346.d10765da.akpm@linux-foundation.org>
	<20070411230700.GA4023@aitel.hist.no>
	<Pine.LNX.4.64.0704120947230.12991@twin.jikos.cz>
	<Pine.LNX.4.64.0704121001400.12991@twin.jikos.cz>
	<461E1B41.90000@aitel.hist.no>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Apr 2007 13:42:57 +0200 Helge Hafting <helge.hafting@aitel.hist.no> wrote:

> Jiri Kosina wrote:
> > On Thu, 12 Apr 2007, Jiri Kosina wrote:
> >
> >   
> >> Could you please
> >> - try booting without any HID devices plugged in (i.e. usb mice, usb 
> >>   keyboards) if the problem persists?
> >> - recompile 2.6.21-rc6-mm1 with git-hid.patch reverted to see if it helps?
> >>     
> >
> > Do you compile with CONFIG_HIDRAW?
> >   
> No, that one is not set. 
> 
> I did use the new SLUB thing - could that possibly be the cause?

yup.

> Going back to SLAB is easy enough. 

Yes, please try that.
