Return-Path: <linux-kernel-owner+w=401wt.eu-S941311AbYCSX6E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941311AbYCSX6E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 19:58:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965569AbYCSWk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 18:40:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55970 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764279AbYCSWky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 18:40:54 -0400
Date: Wed, 19 Mar 2008 15:39:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Jaya Kumar" <jayakumar.lkml@gmail.com>
Cc: armbru@redhat.com, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       linux-fbdev-devel@lists.sourceforge.net, adaplas@pol.net,
       linux-input@vger.kernel.org, dmitry.torokhov@gmail.com
Subject: Re: [PATCH 2/3] fbdev: Make deferred I/O work as advertized
Message-Id: <20080319153946.a5a8060e.akpm@linux-foundation.org>
In-Reply-To: <45a44e480803191530p27ec9575l260d6de063a8d6bf@mail.gmail.com>
References: <87tzjx6vj3.fsf@pike.pond.sub.org>
	<87k5kt6vd3.fsf@pike.pond.sub.org>
	<45a44e480802260611l5a8d0bc9k9cc967bc73b88fac@mail.gmail.com>
	<871w6z6ajs.fsf@pike.pond.sub.org>
	<45a44e480802260701o7c616e3bjd5f86f4143be791b@mail.gmail.com>
	<87iqzjat6e.fsf@pike.pond.sub.org>
	<45a44e480803190424s51b85efbk39ab3bfce4cb924a@mail.gmail.com>
	<20080319113745.d3873de0.akpm@linux-foundation.org>
	<45a44e480803191530p27ec9575l260d6de063a8d6bf@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Mar 2008 06:30:37 +0800
"Jaya Kumar" <jayakumar.lkml@gmail.com> wrote:

> On Thu, Mar 20, 2008 at 2:37 AM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> >
> >  Do we need some of all of that patch in 2.6.25?  I wasn't aware of such a
> >  need.
> >
> >  If the drivers/video/fb_defio.c hunk of that patch fixes something then I'd
> >  be inclined to merge the whole thing - adding a new driver won't hurt
> >  anyone.
> >
> 
> Yes, the defio hunk is a bugfix. I agree with pushing the whole thing
> to 2.6.25 if there are people who need it in 2.6.25. I believe there
> is no risk of impact on anyone else.
> 

Well all we have in the changelog is

  Implement support for the E-Ink Metronome controller.  It provides an
  mmapable interface to the controller using defio support.  It was tested
  with a gumstix pxa255 with Vizplex media using Xfbdev and various X
  clients such as xeyes, xpdf, xloadimage.

grump.  This say nothing at all about the change to drivers/video/fb_defio.c.

a) the changelog _should_ document this change.  Please send a paragraph and
   I'll add it.

b) If this discussion hadn't happened, that bug (whatever it is) would
   have remained unfixed in 2.6.25.  As a direct consequence of poor
   changelogging.

c) This bugfix (whatever it is) should have been in a separate patch.

Thanks.
