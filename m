Return-Path: <linux-kernel-owner+w=401wt.eu-S1757699AbXIWSbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757699AbXIWSbA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 14:31:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755077AbXIWSaw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 14:30:52 -0400
Received: from canuck.infradead.org ([209.217.80.40]:53462 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653AbXIWSav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 14:30:51 -0400
Subject: Re: Urgent bugzilla mainteinance needed
From: David Woodhouse <dwmw2@infradead.org>
To: Natalie Protasevich <protasnb@gmail.com>
Cc: Diego Calleja <diegocg@gmail.com>, linux-kernel@vger.kernel.org,
       David Ames <david@linux-foundation.org>,
       Jon Tollefson <kniht@linux.vnet.ibm.com>,
       "Martin J. Bligh" <mbligh@mbligh.org>
In-Reply-To: <32209efe0709231108v459c3559xf247db2c122513c0@mail.gmail.com>
References: <20070923195821.cab02f42.diegocg@gmail.com>
	 <32209efe0709231108v459c3559xf247db2c122513c0@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 23 Sep 2007 19:30:40 +0100
Message-Id: <1190572240.22181.2.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2007-09-23 at 11:08 -0700, Natalie Protasevich wrote:
> On 9/23/07, Diego Calleja <diegocg@gmail.com> wrote:
> > Take a look at http://bugzilla.kernel.org/show_bug.cgi?id=3710
> >
> > bugzilla tries to send a mail to the reporter, it fails ("unknown user account"),
> > but the error failure is appended as a bugzilla comment. Then bugzilla tries to
> > send that comment to everyone involved in the bug, including the reporter,
> > so it fails again.....Houston, we've a endless loop.
> >
> > There're 540 comments in that bug report already, and the bugme-daemon
> > mail list is being spammed....
> 
> I just sent emails to those who maintain bugzilla software and systems
> that run it, hope someone will be online soon to help alleviate
> this...

Bugzilla really shouldn't be accepting any mail with empty reverse-path
(MAIL FROM:<>)

-- 
dwmw2

