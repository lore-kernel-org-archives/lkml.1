Return-Path: <linux-kernel-owner+w=401wt.eu-S1752707AbXCLTtJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707AbXCLTtJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 15:49:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752810AbXCLTtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 15:49:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42430 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752707AbXCLTtH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 15:49:07 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: Novell
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: refcounting drivers' data structures used in sysfs buffers
Date: Mon, 12 Mar 2007 20:49:01 +0100
User-Agent: KMail/1.9.1
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Maneesh Soni <maneesh@in.ibm.com>, gregkh@suse.de,
       linux-kernel@vger.kernel.org
References: <Pine.LNX.4.44L0.0703121527290.3205-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0703121527290.3205-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703122049.03113.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 12. März 2007 20:31 schrieb Alan Stern:
> On Mon, 12 Mar 2007, Oliver Neukum wrote:
> 
> > > I'm with Dmitry; the whole thing becomes much, much simpler if we put back
> > > your patch and prevent sysfs access after unregistering an attribute 
> > > file.  No API changes are needed, no driver changes are needed, no radical 
> > > core changes are needed,...  All we would have to do is fix the one SCSI 
> > > method to make it use a workqueue.
> > 
> > Try.
> 
> I did.  Didn't you see this message from Saturday:
> 
> http://marc.theaimsgroup.com/?l=linux-kernel&m=117355959020831&w=2

Yes. In this case, silence is partial agreement. However, convincing me
is futile if Linus rejects the approach.

I wrote the original patch. But this problem must be solved. If the
first attempt is rejected, I'll try another.

> I sent it to Linus as well as to all of you.  No replies received so far 
> from anybody.
> 
> >  I don't like reverting my own code. But I predict he'll tell you that a
> > driver's bond with a device should be represented in a data structure
> > that is to be refcounted.
> 
> :-)

Coming to think about it, he might be right there.

	Regards
		Oliver
