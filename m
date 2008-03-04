Return-Path: <linux-kernel-owner+w=401wt.eu-S932300AbYCDWB5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932300AbYCDWB5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 17:01:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756512AbYCDWBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 17:01:48 -0500
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:35435 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757106AbYCDWBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 17:01:46 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=KRbso9rviBn4M+aIg4yyVHoLnOqkrGUiYgcJst32cwldEXuJyUBt5adeHXjRpcsBBeFd08CpwBw2VzECFIV6SeYAUH3Xr0hk7Zp0lRBZk+BagcKnp0LD7+4JAc41ScoujSh4yVm0ZAKwuUvXn+Q2B8IUAze4i3NWJMxtPKrwZ8o=  ;
X-YMail-OSG: x_Y6bOQVM1kHtWRRvfTvxR0M.fCaxf.br6FjXJZRvt.tyE9eqrHVOJcJD2WeQC1hZxITmVg8dw--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: WARNING: at drivers/usb/host/ehci-hcd.c:287
Date: Tue, 4 Mar 2008 14:01:41 -0800
User-Agent: KMail/1.9.6
Cc: Christian Kujau <lists@nerdbynature.de>,
       LKML <linux-kernel@vger.kernel.org>, 0x0007@gmail.com,
       USB list <linux-usb@vger.kernel.org>
References: <Pine.LNX.4.44L0.0803041553320.15986-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0803041553320.15986-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200803041401.41880.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 March 2008, Alan Stern wrote:

> > > How about replacing the
> > > 
> > >         WARN_ON(!ehci->reclaim);
> > 
> > Or bettter yet, just removing it entirely.  ISTR doing that in some
> > patches I've not yet sent for merging, and expect that's what my
> > preferred fix will be ...
> 
> But removing the WARN_ON won't fix the problem.

It fully resolves the $SUBJECT problem.  :)


> The routine still 
> needs to exit immediately if ehci->reclaim isn't set,

It more or less does that already; it does some avoidable
work, but that's not incorrect.


> the root hub isn't running, or the timer has been restarted.

Those are different issues.

- Dave
