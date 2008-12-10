Return-Path: <linux-kernel-owner+w=401wt.eu-S1754739AbYLJNnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739AbYLJNnU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 08:43:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752824AbYLJNnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 08:43:09 -0500
Received: from torres.zugschlus.de ([85.214.68.41]:39927 "EHLO
	torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755AbYLJNnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 08:43:08 -0500
Date: Wed, 10 Dec 2008 14:43:04 +0100
From: Marc Haber <mh+linux-kernel@zugschlus.de>
To: Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: pl2303 - pl2303_open - failed submitting interrupt urb, error -28
Message-ID: <20081210134303.GA9291@torres.zugschlus.de>
References: <20081205121023.GA21963@torres.zugschlus.de> <Pine.LNX.4.44L0.0812051100560.2588-100000@iolanthe.rowland.org> <20081209201120.GB27774@torres.zugschlus.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20081209201120.GB27774@torres.zugschlus.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 09, 2008 at 09:11:20PM +0100, Marc Haber wrote:
> On Fri, Dec 05, 2008 at 11:03:41AM -0500, Alan Stern wrote:
> > Yes it is.  You can force port P of the EHCI controller on bus B to run 
> > at low/full speed by doing:
> > 
> > 	echo P >/sys/class/usb_host/usb_hostB/companion
> > 
> > To allow port P to run at high speed again, use the same command but 
> > write -P instead of P.
> 
> I will try that and report back.

Works fine, thanks!

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Mannheim, Germany  |  lose things."    Winona Ryder | Fon: *49 621 72739834
Nordisch by Nature |  How to make an American Quilt | Fax: *49 3221 2323190
