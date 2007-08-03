Return-Path: <linux-kernel-owner+w=401wt.eu-S1754564AbXHCQtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564AbXHCQtk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 12:49:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751844AbXHCQtb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 12:49:31 -0400
Received: from smtp101.sbc.mail.re2.yahoo.com ([68.142.229.104]:41587 "HELO
	smtp101.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751799AbXHCQtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 12:49:31 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=XYKI4A0FcI8qW3+gKo1Q8nFOmQYVN0m7Ag9wqG5Zc/CofLdy4rWbT5ka7+CtvDSok1/+svamn58QTMPYEZu5N/y8W2qvqOHnpmmUS0P/Gej7UmuQ5bZTE4R9Wz1hlQCg2DVuHSMucjP5l2nA1o3yVCyBhLSPzjA+vPQ6hj6qeSM=  ;
X-YMail-OSG: D5nssioVM1ml7J3rSjBqjVdS4LEprMvnyrHfQUVE_t6mrElzTBQ.QBKncEumv8sUTb.jOM6fs2iiZzVCvvJf.kwhp_wYKXfBFXyBb3SB0oRGv9wi4EmwEhgr._aBaHWxq5XsSrCumkknuKY-
From: David Brownell <david-b@pacbell.net>
To: Dave Jones <davej@redhat.com>
Subject: Re: [linux-usb-devel] [PATCH] USB: Only enable autosuspend by default on certain device classes
Date: Fri, 3 Aug 2007 09:49:27 -0700
User-Agent: KMail/1.9.6
Cc: Jiri Kosina <jikos@jikos.cz>, Adam Kropelin <akropel1@rochester.rr.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Oliver Neukum <oliver@neukum.org>, Rogan Dawes <lists@dawes.za.net>,
       Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>,
       linux-usb-devel@lists.sourceforge.net
References: <20070803140909.GA19245@srcf.ucam.org> <Pine.LNX.4.64.0708031730180.26230@twin.jikos.cz> <20070803154838.GH21379@redhat.com>
In-Reply-To: <20070803154838.GH21379@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200708030949.28252.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 August 2007, Dave Jones wrote:
>  > > Plus if you're connected to such a device for monitoring purposes you're 
>  > > probably powered by it as well, so you have little to gain from suspend 
>  > > even if it works.
>  > 
>  > I currently don't have any HID UPS by hand to verify, but I'd be surprised 
>  > if they would advertise remote wakeup capability ... ?
> 
> Looks like mine does..

Makes sense.  You don't want to force the host to ignore all
power events.  As with a laptop, you might want servers to
cleanly hibernate before the (UPS) battery runs out...

- Dave

