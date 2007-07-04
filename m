Return-Path: <linux-kernel-owner+w=401wt.eu-S1761241AbXGDPCZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761241AbXGDPCZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 11:02:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758174AbXGDPCS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 11:02:18 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:43534 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758491AbXGDPCR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 11:02:17 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [linux-pm] [PATCH] Remove process freezer from suspend to RAM pathway
Date: Wed, 4 Jul 2007 17:02:16 +0200
User-Agent: KMail/1.9.7
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
References: <20070703224215.GA30081@srcf.ucam.org> <Pine.LNX.4.44L0.0707041030540.25704-100000@netrider.rowland.org> <20070704145818.GA7784@srcf.ucam.org>
In-Reply-To: <20070704145818.GA7784@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200707041702.16583.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 4. Juli 2007 schrieb Matthew Garrett:
> On Wed, Jul 04, 2007 at 10:38:47AM -0400, Alan Stern wrote:
> 
> > Okay, I agree that (1) can be handled without too much effort.  But 
> > doing it adds an extra test to _every_ driver's I/O pathway.  Freezing 
> > userspace does not incur all this additional overhead.
> 
> For runtime PM to work it's already necessary to have a test in that 
> path to check if the device is suspended. I can't see how this adds any 
> overhead to the common case.

No,

you just make sure the device reports to upper layers when it might
be busy. The USB layer manages this quite well without burdening
the common case.

	Regards
		Oliver
