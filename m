Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539Ab0CCORX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 09:17:23 -0500
Received: from mail-ew0-f220.google.com ([209.85.219.220]:34172 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754301Ab0CCORW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 09:17:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sv/BDfo5rIQ+iKy2GQHZBdO3oYvTBX47bBfJdlzmCtWABsJWIwfYbrenV/ALxULvM3
         zwIgO+peC4OgC0NamPoj/zd5IB7xasHf8xeRcqNc9yrXsHIr9uk4ExFyM0hrcNQtLS+o
         xWuekZa+/OvW5+KSPUBE6LYKm+Rmot3ycohEk=
Date: Wed, 3 Mar 2010 15:17:18 +0100
From: Johan Hovold <jhovold@gmail.com>
To: peter@piie.net
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-usb@vger.kernel.org
Subject: Re: [BUG] usb-serial / pl2302 corrupted receive
Message-ID: <20100303141718.GA15162@localhost>
References: <cone.1267466820.296261.3385.1000@deskpiie>
 <20100302235353.GB2196@kroah.com>
 <20100303114705.33716f9pnen8a8kc@webmail.df.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100303114705.33716f9pnen8a8kc@webmail.df.eu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 03, 2010 at 11:47:05AM +0100, peter@piie.net wrote:
> Quoting Greg KH <greg@kroah.com>:
> > On Mon, Mar 01, 2010 at 07:07:00PM +0100, Peter Feuerer wrote:
> >> I connected two pls2302 usb-serial converters to two different
> >> usb-ports of my machine and connected them with a rs232-nullmodem
> >> cable to each other.
> >>
> >> Terminal1:
> >> cat /dev/ttyUSB1
> >>
> >> Terminal2:
> >> while true; do echo 123456789012345678901234567890 > /dev/ttyUSB0 ; done
> >
> > cat and echo are known to not work well with usb to serial devices.  Can
> > you duplicate this with a "real" tty program like minicom or something
> > else?
> 
> I will try to set up a test use-case which uses kermit.
> 
> But there is a calltrace in kernel log when using cat & echo, so  
> something in the driver went wrong.
> Thus there is a bug which can be reproduced and it should be fixed,  
> don't you agree?

Not necessarily. The warning you attached to your first post is a false
one (it has been fixed in 2.6.33) and is not directly related to the
problem you describe.

/Johan

