Return-Path: <linux-kernel-owner+w=401wt.eu-S1758801AbYIMAGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758801AbYIMAGS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 20:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757329AbYIMAGF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 20:06:05 -0400
Received: from smtp126.sbc.mail.sp1.yahoo.com ([69.147.65.185]:23312 "HELO
	smtp126.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756618AbYIMAGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 20:06:05 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Sep 2008 20:06:04 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=iQxiLMX0aZAcx6npSOEgIucMO7oD7Bkzq6hAxXwCK9cH4xrjNXkH6gjVhB9Ki6JpSobZX/yixIUv2t5iTTp0lzpv8L72Hzmd+DgEFIoaPwmxyQeWG44nkYlqFNxN6/N9GZbHYIGWZxLE08+2JBc+oLXa/RK/1MnCs4ttkhN+RbI=  ;
X-YMail-OSG: I96Qh6gVM1mmoKsVpZ6LOdze7qON_x3RgcfBodH3ugeU2fPEC9GIglyc2o5kR05NVzNjkMPy4qGZWfXairpiE1bHDAr8BVWpJGZb.tUKROeUHC9USl3p6sHL5kPlcKLjFB8-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Partition check considered as error is breaking mounting in 2.6.27
Date: Fri, 12 Sep 2008 16:59:20 -0700
User-Agent: KMail/1.9.9
Cc: herton@mandriva.com.br, me@bobcopeland.com, stern@rowland.harvard.edu,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       bogdano@mandriva.com.br, lcapitulino@mandriva.com.br,
       draconux@gmail.com, dlallement@mandriva.com, pterjan@mandriva.com,
       axboe@kernel.dk
References: <Pine.LNX.4.44L0.0809121423030.14509-100000@iolanthe.rowland.org> <200809121646.09641.david-b@pacbell.net> <20080912165222.9ed7fc25.akpm@linux-foundation.org>
In-Reply-To: <20080912165222.9ed7fc25.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809121659.21743.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > ________________________________________________________________disk->disk_name, p);
> > > -______________________________________________continue;
> > > ________________________________}
> 
> wtf-your-email-client-is-insane.

I have no idea where that came from.  Wasn't in the original or
in my copy.


> > So that now deserves to be KERN_WARN not KERN_ERR, yes?
> 
> spose so.
> 
> I'm fairly unenthused about the recent KERN_correctness fad since it
> went and broke sysrq-T output (you have to set the loglevel beforehand
> to avoid getting only partial output).

On development systems I generally "echo 8 > /proc/sysrq*"
to make sure KERN_DEBUG isn't hidden.

In this case it's just that I saw flamage a few minutes
earlier from someone trying to keep a distro boot from
spewing scarey messages for things that were NOT errors.
Like ... this message.  :)

