Return-Path: <linux-kernel-owner+w=401wt.eu-S1754580AbYHNVnH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580AbYHNVnH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 17:43:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751352AbYHNVm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 17:42:56 -0400
Received: from ns1.suse.de ([195.135.220.2]:60757 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019AbYHNVmz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 17:42:55 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: Novell
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] Power management for SCSI
Date: Thu, 14 Aug 2008 23:43:55 +0200
User-Agent: KMail/1.9.9
Cc: Pavel Machek <pavel@suse.cz>, linux-pm@lists.linux-foundation.org,
       James.Bottomley@hansenpartnership.com,
       "Linux-pm mailing list" <linux-pm@lists.osdl.org>,
       kernel list <linux-kernel@vger.kernel.org>, teheo@novell.com
References: <Pine.LNX.4.44L0.0808141141570.2846-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0808141141570.2846-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200808142343.56505.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag 14 August 2008 17:47:02 schrieb Alan Stern:
> > I don't really argue against flushing the caches. But I cannot that this would
> > demand that we should implement autopsuspend for SCSI. It seems like
> > overengineering to me.
> 
> Think of it in two parts: idle-timeout detection and autosuspend.  
> Presumably you don't object to the idle-timeout detection (which is 
> needed for powering down links in general), and you don't argue against 
> the cache-flushing part of autosuspend.  Taken together, that's about 
> 90% of my proposal.  So what is the objectionable 10%?

The core problem is that you insist on a rigid bottom-to-top flow of
autosuspensions. That's good for systems like USB and PCI which
are trees for PM purposes. It makes no sense for true busses with
equal members on the bus.

	Regards
		Oliver

