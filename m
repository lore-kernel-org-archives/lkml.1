Return-Path: <linux-kernel-owner+w=401wt.eu-S934247AbXCVV3O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934247AbXCVV3O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 17:29:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934246AbXCVV3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 17:29:14 -0400
Received: from smtp107.sbc.mail.mud.yahoo.com ([68.142.198.206]:43993 "HELO
	smtp107.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S934240AbXCVV3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 17:29:12 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=u4fkDtG6bw9NJIsAs/0V4GQkK4IJmm6TygkY1LwAlPoHZz2ZkZoca9SX2zRcm4e2ZuViqVoOVepW5XhayAUQLXJf2DHLgGbp3GLNOYwF7oTQ3T3wK87KLEygZws4BFw3ghkCQd8c5Q6/8yj/SIE1azbbJreEjywqlqKcZ9EpFwU=  ;
X-YMail-OSG: dRXF1H4VM1nHhsB56RsWod2oKROGfRFYxiSKsZpLM8uhkPmnRaO2gXhCKwLhS2lM8GBE5_MQcmCu4BrPBU_IjFIx8xWSNpFHowbIeLnI2CPZN2Hxl2.3w9pZfpq75mVuzLfRtVYrqRtLuvw-
From: David Brownell <david-b@pacbell.net>
To: linux-usb-devel@lists.sourceforge.net
Subject: Re: [linux-usb-devel] possible USB regression with 2.6.21-rc4: iPod doesn't work
Date: Thu, 22 Mar 2007 14:29:11 -0700
User-Agent: KMail/1.7.1
Cc: Tino Keitel <tino.keitel@gmx.de>, Alan Stern <stern@rowland.harvard.edu>,
       linux-kernel@vger.kernel.org
References: <20070322085451.GB10598@dose.home.local> <Pine.LNX.4.44L0.0703221539440.4669-100000@iolanthe.rowland.org> <20070322195448.GA17521@dose.home.local>
In-Reply-To: <20070322195448.GA17521@dose.home.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703221429.12029.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 22 March 2007 12:54 pm, Tino Keitel wrote:
> On Thu, Mar 22, 2007 at 15:40:40 -0400, Alan Stern wrote:
> > 	  _Something_ is generating those overcurrent 
> > warnings, and it sure looks like a hardware malfunction.
> 
> But it works with 2.6.20.

So can you bisect to find what caused the problem?

We've been afflicted with such strange overcurrent messages
off and on for some time.  Some hardware triggers them, while
most doesn't, and the USB developers don't have any of the
hardware that triggers it (that almost goes without saying).

It's been clear to me that _something_ the software does is
making that more likely to happen.

One thing we've been lacking is anything like a usable clue
as to what kind of changes would have that failure mode ...
and thus, what kind of changes could remove it.

- Dave
