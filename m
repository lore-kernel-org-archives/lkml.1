Return-Path: <linux-kernel-owner+w=401wt.eu-S1752857AbXCLUPd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857AbXCLUPd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 16:15:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752860AbXCLUPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 16:15:33 -0400
Received: from ns.suse.de ([195.135.220.2]:36872 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752857AbXCLUPc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 16:15:32 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: Novell
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: refcounting drivers' data structures used in sysfs buffers
Date: Mon, 12 Mar 2007 21:15:31 +0100
User-Agent: KMail/1.9.1
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Maneesh Soni <maneesh@in.ibm.com>, gregkh@suse.de,
       linux-kernel@vger.kernel.org
References: <Pine.LNX.4.44L0.0703121557360.4003-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0703121557360.4003-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703122115.32971.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 12. März 2007 21:03 schrieb Alan Stern:
> On Mon, 12 Mar 2007, Oliver Neukum wrote:
> 
> > > >  I don't like reverting my own code. But I predict he'll tell you that a
> > > > driver's bond with a device should be represented in a data structure
> > > > that is to be refcounted.
> > > 
> > > :-)
> > 
> > Coming to think about it, he might be right there.
> 
> There still would be a synchronization problem.  Refcounts don't solve
> races; they only solve lifetime problems.  And you would still have to
> change the sysfs API, plus all the other stuff...
> 
> Do you think Linus would listen if all three of us (plus maybe Greg) tried 
> to convince him?

No. He'd tell you that a crap API should be changed.

	Regards
		Oliver
