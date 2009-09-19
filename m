Return-Path: <linux-kernel-owner+w=401wt.eu-S1752835AbZISQgJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835AbZISQgJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 12:36:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751798AbZISQgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 12:36:08 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:55837 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975AbZISQgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 12:36:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bmA5z2IjbgxExpmDB95PUdIJXwRLelAVKBM7Ntcr9MdRSjHCXMALo3HsPbrzLWvTR5
         U0DFf1mz6u0004zYfNoL50kM3lbvSLs7IDw9D+orULMRGs0goeZuetPo973TS8/GT5m/
         89UM/TYtdZkD0295LckZg1YkU4vhKqIGxSTHc=
Date: Sat, 19 Sep 2009 18:36:07 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Johan Hovold <jhovold@gmail.com>, Greg KH <greg@kroah.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-usb@vger.kernel.org,
       e9hack <e9hack@googlemail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: ftdi_sio: Fix read regression in 2.6.31.
Message-ID: <20090919163607.GA16949@localhost>
References: <20090919160347.GA14156@localhost>
 <Pine.LNX.4.44L0.0909191217430.15223-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0909191217430.15223-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 19, 2009 at 12:20:53PM -0400, Alan Stern wrote:
> On Sat, 19 Sep 2009, Johan Hovold wrote:
> > Use ASYNCB_INITIALIZED to determine when to stop reading.
> This is a good change.  It should be made in all the serial drivers, 
> not just ftdi_sio.  How'd you like to submit patches for all the rest 
> of the drivers?

Sure, I'll do that tomorrow.

/Johan

