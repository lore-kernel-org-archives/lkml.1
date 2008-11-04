Return-Path: <linux-kernel-owner+w=401wt.eu-S1753371AbYKDGwP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371AbYKDGwP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 01:52:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753907AbYKDGvu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 01:51:50 -0500
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:27827 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753753AbYKDGvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 01:51:49 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=5FbMaQeKu5IrefMPfDaylZ5/kz/IDYfjY8O647LwiJidUlv8ctxiCefPbUQ/McS+m+yTUljekelBmnEE2RAl3YWJ0T/mPjxvp4T/FLuLq0mfFgdpt7nsQjt+kBZHIZ+Ny7jXvep2qSg585Rml/1UAAUMLWp+J+EpKaXY15cEveA=  ;
X-YMail-OSG: 9aVXbSYVM1k.DdP9t2.hCAWqhGtMoPHwzlWrO.BBd5aO5AmC_K9Ntu92IfyXF_ZXWWzTTRVkHkllqljHlAJ4GZeeBbGBgPNu6cKip03lxGJtx17373rAv3MG65LC18ERaOt406FsqCcs9Y6xzhyY_Aj4VtCoQDJWHbZM._w-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] EHCI pci-quirks.c: wait for BIOS handoff too long
Date: Mon, 3 Nov 2008 23:51:46 -0700
User-Agent: KMail/1.9.10
Cc: Steven Noonan <steven@uplinklabs.net>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>
References: <1225774635-15032-1-git-send-email-steven@uplinklabs.net> <490FDE72.9060400@garzik.org>
In-Reply-To: <490FDE72.9060400@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811032251.47110.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 November 2008, Jeff Garzik wrote:
> That tells us nothing about the original reason for choosing the 5000 
> value, and what if any impact lowering the value has on those who 
> thought 5000 was needed.

You mean, the source code should have a comment about that?

The *original* BIOS-broken timeout was some fraction of a second
(I'm thinking 250 msec, maybe not), but I got some reports about
BIOS versions that were too sluggish to work with that.  ISTR
that half a second wasn't quite reliable, so 1+ seconds seemed
to be called for.

So rather than incremental increases, it went from 250 msec up
to 5000 msec, and this is the first complaint we've had about
that in *many* years.

- Dave
