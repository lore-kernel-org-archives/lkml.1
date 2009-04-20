Return-Path: <linux-kernel-owner+w=401wt.eu-S1757271AbZDTURi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271AbZDTURi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 16:17:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757036AbZDTUQ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 16:16:27 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:60355 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757068AbZDTUQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 16:16:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Os7PTsC46cEh7NkVBfsnHDBrIvJIupHx4xzCck4k0lKjd8sQOXJDhIOaaMY6cLgM7S
         d8kUDBB6Vf+T1k53NVv8XpZOt4Fe5NUylq6TXnDD7AoaWuKoIine0crZCaPOpHYGKFb8
         JuvLCVJJAKbbA2iSeQ6Oxpdsxq88QJ3Jh2RbE=
Subject: Re: [BISECTED] [REGRESSION] can't anymore even do a
 s2ram-s2disk-s2ram cycle on acer aspire 5720G
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>, Alan Stern <stern@rowland.harvard.edu>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-usb <linux-usb@vger.kernel.org>
In-Reply-To: <200904202124.47477.rjw@sisk.pl>
References: <1239061976.4705.16.camel@maxim-laptop>
	 <20090407072651.GC1408@ucw.cz>  <200904202124.47477.rjw@sisk.pl>
Content-Type: text/plain
Date: Mon, 20 Apr 2009 23:16:15 +0300
Message-Id: <1240258575.24681.13.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-04-20 at 21:24 +0200, Rafael J. Wysocki wrote:
> On Tuesday 07 April 2009, Pavel Machek wrote:
> > Hi!
> > 
> > > Also this commits narrows down the search, now it is clear that this is
> > > usb related. No wonder bios pokes at usb on resume and stalls.....
> > 
> > So obvious next step is to compile-out usb support and see what
> > happens?
> 
> Well, Maxim has already done more than that.  Please look a the entire thread.

That is true, I even compiled kernel back to 2.6.19, and used absolutly
minimal driver configuration (ahci + vga console + keyboard).

(Yes, screen here doesn't came back to life without nvidia propertary
drivers, but system otherwise works fine, and this huge bug, was
confirmed by many peoples out of which I probably an only one with
nvidia device.)

But, notice, that in 2.6.30-rc, same regression happens, but it isn't
anymore due to ehci (I even copied suspend/resume code from the 'good'
version), thus there is some hope that addtional bisect might reveal
things (and I finally managed to set up distcc properly over wlan, and
get 100% on all systems, well 2 systems, the trick is to use many
threads, something like 15 or so, and I can now do full bisect cycle in
about 10 seconds)


Best regards,
	Maxim Levitsky

