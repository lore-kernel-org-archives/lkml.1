Return-Path: <linux-kernel-owner+w=401wt.eu-S1755678AbYEQG7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755678AbYEQG7d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 02:59:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751912AbYEQG7Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 02:59:24 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:7983 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870AbYEQG7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 02:59:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=EfuM30dZ66VOLeX+qkszLA5RTqZgERzoATXbODa+rFBeurQXOALnRO/67lgbDfaRRvcbUR9aq1lnKkM3mzlRSirLfvzwig4dKkTnpPWnnvUagN0kB1R9EYUmt3IMbjYvFGtzAna6EsjTLOulfVleeaffCpkhtzlx3C/3nijd73U=
Message-ID: <8db1092f0805162359k2def1738s91cc78d48bea2581@mail.gmail.com>
Date: Sat, 17 May 2008 08:59:22 +0200
From: "Maciej Rutecki" <maciej.rutecki@gmail.com>
To: "Alan Stern" <stern@rowland.harvard.edu>
Subject: Re: [Re: Linux 2.6.26-rc2] Write protect on on
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
In-Reply-To: <Pine.LNX.4.44L0.0805162056230.13416-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8db1092f0805160755u54914884ibe1ed8a23b8e1015@mail.gmail.com>
	 <Pine.LNX.4.44L0.0805162056230.13416-100000@netrider.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/5/17 Alan Stern <stern@rowland.harvard.edu>:

> The best way to gather more data is to use usbmon and trace what
> happens when you plug in the drive (see Documentation/usb/usbmon.txt).
> If you collect traces under both 2.6.25.4 and 2.6.26-rc2 then we can
> compare them to see what has changed.
>
> You don't have to trace the mount command; the activity at plug-in time
> will be sufficient.
>
> Alan Stern
>
>

2.6.25.4 (works fine):
http://unixy.pl/maciek/download/kernel/2.6.25.4/syslog_debug.txt
http://unixy.pl/maciek/download/kernel/2.6.25.4/usbmon.txt

2.6.26-rc2 ("write protect is on" problem; can't mount device):
http://unixy.pl/maciek/download/kernel/2.6.26-rc2/syslog_debug.txt
http://unixy.pl/maciek/download/kernel/2.6.26-rc2/usbmon.txt

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
