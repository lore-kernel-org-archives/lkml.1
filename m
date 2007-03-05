Return-Path: <linux-kernel-owner+w=401wt.eu-S1751493AbXCEDht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751493AbXCEDht (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 22:37:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751497AbXCEDht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 22:37:49 -0500
Received: from web52508.mail.yahoo.com ([206.190.48.191]:27438 "HELO
	web52508.mail.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751493AbXCEDhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 22:37:48 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=ci8F0xqx9D2Z5LK8SUSofBkYjB0MB7wVeuzjt7TLUj76W0tCyUDCWpGtQPF36r2W0EV5CY0RKSQO7i+bRb6QjynUwn/eFWG8b87Ao2kQitR78YKrVn84KJpRtC7kKxsyfUyrJkUk6sjq4aq42RZpoHa6sLyYaeoCi90mN0HLrXw=;
X-YMail-OSG: 4CfDdvgVM1kVpKQDuqmvNEddPe8ZIxtl5GZMhw7veON3IUDVa5pOKqaVF23Jc5cL7Qbh9Xeev3GLHi5NmCr1YiikRK0ONdOGU3HXTa60j6Nyf6w93QEvNlxszXOJ.ZwyKosnOUPZITJXsrzQ5VbDNyMctA--
Date: Sun, 4 Mar 2007 19:37:47 -0800 (PST)
From: Marc Perkel <mperkel@yahoo.com>
Subject: Re: Raid 10 Problems?
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.61.0703050430280.23714@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <382470.25191.qm@web52508.mail.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Jan Engelhardt <jengelh@linux01.gwdg.de> wrote:

> 
> On Mar 4 2007 19:17, Marc Perkel wrote:
> >Thanks - because of your suggestion I had found the
> >instructions. But you have some interesting options
> >set. 
> >
> >-N nicearray -b internal -e 1.0
> >
> >Are these important?
> 
>   -N? What's in a name? I suppose, it's not so
> important.
>   (Arrays are identified by their UUID anyway. But
> maybe
>   udev can do something with the name someday as it
> does
>   today with /dev/disk/*.)

Not worth starting over for.

> 
>   -b internal -- seems like a good idea to speed up
>   resynchronization.

I'm trying to figure out what the default is. 

> 
>   -e 1.0 -- I wonder why the new superblock format
> is
>   not default in mdadm (0.90 is still used).
> 

Looks interesting for big arrays but not sure it's
worth starting over for. Trying to get through a 2
hour sync using 4 500gb sata 2 drives.

> 
> >pci=nommconf iommu=soft
> 
> The nvidia chipset corruption problem?
> 

Yep - that's the one.



 
____________________________________________________________________________________
It's here! Your new message!  
Get new email alerts with the free Yahoo! Toolbar.
http://tools.search.yahoo.com/toolbar/features/mail/
