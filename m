Return-Path: <linux-kernel-owner+w=401wt.eu-S1763420AbXHCOw5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763420AbXHCOw5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 10:52:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762235AbXHCOwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 10:52:49 -0400
Received: from smtp113.sbc.mail.re2.yahoo.com ([68.142.229.92]:46182 "HELO
	smtp113.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1762352AbXHCOws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 10:52:48 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=roBtKpOTGg3+UhDFaMbowPW3tbj0Ufpup8eL9/9YNRH4VYol0C0XWvOMvw8X4850U9nQ8NO3w+2fp/DwxYiuD2cVXDhVHPa90+c8IOO8+rYMJyQilB0eP5/JWPyhn7YqggN5Kdh3Bg8KVKq6iVGzFez3nehvuoOCgyJ1OgPpoAM=  ;
X-YMail-OSG: j4kt9XIVM1kDCtObl06bbF1f2IAHk.7Cq6iPXvqk5Aa.jSAIIUTKojstnudnhc.ULO8FbvK0_v3WhRLD8CTNb8kAmPgNZyc.SNMjblJheCR1cVXM8zVXKw4V0D.AdfLGYoX_3YRqcDAwviU-
From: David Brownell <david-b@pacbell.net>
To: Dave Jones <davej@redhat.com>
Subject: Re: [linux-usb-devel] [PATCH] USB: Only enable autosuspend by default on certain device classes
Date: Fri, 3 Aug 2007 07:52:45 -0700
User-Agent: KMail/1.9.6
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Greg KH <gregkh@suse.de>,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <20070802235613.GA9487@srcf.ucam.org> <200708022306.08410.david-b@pacbell.net> <20070803142255.GA11942@redhat.com>
In-Reply-To: <20070803142255.GA11942@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708030752.45454.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 August 2007, Dave Jones wrote:
> On Thu, Aug 02, 2007 at 11:06:08PM -0700, David Brownell wrote:
>  
>  > Sometimes when I plug in a USB device I get a dialog asking if I want to
>  > configure it ... surely it would be possible to have that mechanism also
>  > consult a database (part of a distro, or on some web server) for info
>  > about the device, and offer the option for to poke at the device a bit to
>  > see if it behaves.  That stuff works for music CDs; why not USB devices?
> 
> Not everyone who uses USB devices uses X.

True, but for desktop users there doesn't seem to be any
real counter-argument to my point.


> It's a bit difficult to pop up a "unscrew my printer" dialog when you're
> on the console.

Right.  Remotely operated systems (like servers) might
need some kind of "default assume-broken" setting.

- Dave
