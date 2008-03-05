Return-Path: <linux-kernel-owner+w=401wt.eu-S934390AbYCEAab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934390AbYCEAab (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 19:30:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760456AbYCEAaQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 19:30:16 -0500
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:25040 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758100AbYCEAaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 19:30:15 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=m9uTj0thrwus9M2gH/xbfJXmaB/JFBn1bnnLB2C1XrJ75GzYW7Eabfbmx+AtZLX6zMEe2VsNUwmFqQh8n3K+O0LoKst7bICyDisT1uw0C9IRD8MU8vvrHoZzEGPNc7Ans1UDJXnVDffghnYRPbDp60TE7lQQw/Sc7li5Z5wIks8=  ;
X-YMail-OSG: PY_918gVM1m0q74r6mI7d2Aw5dpPbWGTqmv5s55UuMROqTVcIoEFlrQsaoPWVS57HwF72_jiWA--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Christian Kujau <lists@nerdbynature.de>
Subject: Re: WARNING: at drivers/usb/host/ehci-hcd.c:287
Date: Tue, 4 Mar 2008 16:30:11 -0800
User-Agent: KMail/1.9.6
Cc: Alan Stern <stern@rowland.harvard.edu>,
       LKML <linux-kernel@vger.kernel.org>, 0x0007@gmail.com,
       USB list <linux-usb@vger.kernel.org>
References: <Pine.LNX.4.44L0.0803041553320.15986-100000@iolanthe.rowland.org> <200803041401.41880.david-b@pacbell.net> <alpine.DEB.1.00.0803050012090.5974@sheep.housecafe.de>
In-Reply-To: <alpine.DEB.1.00.0803050012090.5974@sheep.housecafe.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803041630.11832.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 March 2008, Christian Kujau wrote:
> On Tue, 4 Mar 2008, David Brownell wrote:
> >>> Or bettter yet, just removing it entirely.  ISTR doing that in some
> >>> patches I've not yet sent for merging, and expect that's what my
> >>> preferred fix will be ...
> >>
> >> But removing the WARN_ON won't fix the problem.
> >
> > It fully resolves the $SUBJECT problem.  :)
> 
> ...and if it's a safe thing to do, I'm happy with it. I really have no 
> clue why shutting up a WARN_ON has no (future) implications but if you 
> say so I trust you :)

Carrying that WARN_ON forward was inappropriate, so
removing it is a safe thing to do.

There are other lurking issues though.

- Dave
