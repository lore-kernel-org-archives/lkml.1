Return-Path: <linux-kernel-owner+w=401wt.eu-S1759369AbYCSTs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759369AbYCSTs5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 15:48:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755748AbYCSTcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:32:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58060 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755721AbYCSTcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:32:46 -0400
Date: Wed, 19 Mar 2008 11:37:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Jaya Kumar" <jayakumar.lkml@gmail.com>
Cc: "Markus Armbruster" <armbru@redhat.com>, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       linux-fbdev-devel@lists.sourceforge.net, adaplas@pol.net,
       linux-input@vger.kernel.org, dmitry.torokhov@gmail.com
Subject: Re: [PATCH 2/3] fbdev: Make deferred I/O work as advertized
Message-Id: <20080319113745.d3873de0.akpm@linux-foundation.org>
In-Reply-To: <45a44e480803190424s51b85efbk39ab3bfce4cb924a@mail.gmail.com>
References: <87tzjx6vj3.fsf@pike.pond.sub.org>
	<87k5kt6vd3.fsf@pike.pond.sub.org>
	<45a44e480802260611l5a8d0bc9k9cc967bc73b88fac@mail.gmail.com>
	<871w6z6ajs.fsf@pike.pond.sub.org>
	<45a44e480802260701o7c616e3bjd5f86f4143be791b@mail.gmail.com>
	<87iqzjat6e.fsf@pike.pond.sub.org>
	<45a44e480803190424s51b85efbk39ab3bfce4cb924a@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Mar 2008 19:24:25 +0800 "Jaya Kumar" <jayakumar.lkml@gmail.com> wrote:

> On Wed, Mar 19, 2008 at 6:45 PM, Markus Armbruster <armbru@redhat.com> wrote:
> >
> >  Any progress on this?
> >
> >  Considering that fb_defio is utterly broken without the fix (writing
> >  the frame buffer makes the VM endlessly invoke vm_ops.page_mkwrite()),
> >  wouldn't it make sense to merge the fix even if it still has issues?
> >
> 
> Yes, Andrew has merged the fix into -mm. I see it in mmotm
> 
> http://userweb.kernel.org/~akpm/mmotm/broken-out/fbdev-defio-and-metronomefb-v4.patch
> 

Do we need some of all of that patch in 2.6.25?  I wasn't aware of such a
need.

If the drivers/video/fb_defio.c hunk of that patch fixes something then I'd
be inclined to merge the whole thing - adding a new driver won't hurt
anyone.
