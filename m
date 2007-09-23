Return-Path: <linux-kernel-owner+w=401wt.eu-S1758585AbXIWSea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758585AbXIWSea (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 14:34:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756344AbXIWSeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 14:34:21 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:40135 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756101AbXIWSeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 14:34:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=POXmmdlY9mNjeulOnLEScOpUdKxKJvA6FpS2s9qCuQkFSDMZj9DCfTf/HYo5q1zdB+KhZvd6wIgD22DTX3gvZbNrI9EJayBsre6sOVX2u1sMvEXBunxDQy13dXL9s3aPNEz/KlZu+mQPlrU3KulOb1g51FkZ8ds2juZl9jpIXYo=
Message-ID: <32209efe0709231134t1dda4965i6e1d49a8d134c664@mail.gmail.com>
Date: Sun, 23 Sep 2007 11:34:19 -0700
From: "Natalie Protasevich" <protasnb@gmail.com>
To: "David Woodhouse" <dwmw2@infradead.org>
Subject: Re: Urgent bugzilla mainteinance needed
Cc: "Diego Calleja" <diegocg@gmail.com>, linux-kernel@vger.kernel.org,
       "David Ames" <david@linux-foundation.org>,
       "Jon Tollefson" <kniht@linux.vnet.ibm.com>,
       "Martin J. Bligh" <mbligh@mbligh.org>
In-Reply-To: <1190572240.22181.2.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070923195821.cab02f42.diegocg@gmail.com>
	 <32209efe0709231108v459c3559xf247db2c122513c0@mail.gmail.com>
	 <1190572240.22181.2.camel@shinybook.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/23/07, David Woodhouse <dwmw2@infradead.org> wrote:
>
> On Sun, 2007-09-23 at 11:08 -0700, Natalie Protasevich wrote:
> > On 9/23/07, Diego Calleja <diegocg@gmail.com> wrote:
> > > Take a look at http://bugzilla.kernel.org/show_bug.cgi?id=3710
> > >
> > > bugzilla tries to send a mail to the reporter, it fails ("unknown user account"),
> > > but the error failure is appended as a bugzilla comment. Then bugzilla tries to
> > > send that comment to everyone involved in the bug, including the reporter,
> > > so it fails again.....Houston, we've a endless loop.
> > >
> > > There're 540 comments in that bug report already, and the bugme-daemon
> > > mail list is being spammed....
> >
> > I just sent emails to those who maintain bugzilla software and systems
> > that run it, hope someone will be online soon to help alleviate
> > this...
>
> Bugzilla really shouldn't be accepting any mail with empty reverse-path
> (MAIL FROM:<>)

Ah, then should be easy fix then. I don't have access to the system
though, will have to helplessly wait until one of the guys picks up...
:(
Thanks...
>
> --
> dwmw2
>
>
