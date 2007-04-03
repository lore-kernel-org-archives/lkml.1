Return-Path: <linux-kernel-owner+w=401wt.eu-S1161024AbXDCRn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161024AbXDCRn0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 13:43:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161029AbXDCRn0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 13:43:26 -0400
Received: from smtp005.mail.ukl.yahoo.com ([217.12.11.36]:32103 "HELO
	smtp005.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1161024AbXDCRnZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 13:43:25 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.it;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=1Y4i+KKtY4y0KfOuBeFE8JXDvhASnhc4iFGukXk476iwv7f33aGFVnTZC7EIgXarQ4B+DBu9/u0k9DJ+asnqs4GQl4v6t0FP7FuFrkavqUcpF5VDfSKZgjWwTs+MBWatbyMsg3gyrlOY54Fwl2EG2izTH6jq9vOcIkTNaWtuKVY=  ;
X-YMail-OSG: 7CWLbbYVM1m37dxWW57qbEO1uDbHhbFTVO7W1BIhbTCIh8AuC.4UPCtEqGS978kXeBb8R7LKa55_VgKTyAq2gVhRV2MYsMdlpx__gGhbcPQvSDig
From: Blaisorblade <blaisorblade@yahoo.it>
To: Antoine Martin <antoine@nagafix.co.uk>
Subject: Re: [uml-devel] [RFC] UML kernel & rootfs bundle with every kernel release ?
Date: Tue, 3 Apr 2007 19:43:14 +0200
User-Agent: KMail/1.9.6
Cc: Jeff Dike <jdike@addtoit.com>, devzero@web.de,
       user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
References: <1712880100@web.de> <20070402020530.GA589@c2.user-mode-linux.org> <4610D937.20002@nagafix.co.uk>
In-Reply-To: <4610D937.20002@nagafix.co.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200704031943.15001.blaisorblade@yahoo.it>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On lunedì 2 aprile 2007, Antoine Martin wrote:
> Jeff Dike wrote:
> > On Sun, Apr 01, 2007 at 08:58:45PM +0100, Antoine Martin wrote:
> >> I reckon that one critical thing which could drastically increase the
> >> user base would be to have a working virtual framebuffer implementation.
> >
> > Why?  I've never understood what a framebuffer gives you that you
> > don't have now.
>
> Just like the network auto-configuration via dhcp,
Hmm... for that to be completely plug-and-play you need to make sure a dhcp 
server on the host exists.

Vmware runs a separate DHCP server exactly for this, even if we should avoid 
that as much as possible.

> it would allow users 
> to download images+kernel and run them like appliances without
> understanding anything about X or UML, just click and run.

> We are all capable of setting up Xvfb here, but most users are not,
> which is why they download ready-made images.

What about installing and pre-configuring Xnest on the image? With a suitable 
script calling xhost on the host, it just works.

This project did it:
http://umlbuilder.sourceforge.net/

although it stopped working for me ages ago (probably for some UML bug). I 
built a Mandrake image (that I now lost) with Xnest configured. With a script 
on the host which passes the host IP and that calls xhost, it should work 
easily. And btw, we need a standard startup script anyway.

> It would also make it a lot easier to focus on writing a management UI,
> hell if there isn't one shortly after, I'll do one myself!

Why not one management UI running from the host, a-la vmware? Possibly, with 
as much code as possible in scripting languages, for better transparency.

> Think of a UML browser image (running IE via wine in a limited image
> with just X + wine + IE - I would much prefer that to having wine+IE
> installed locally), testing framebuffer apps like gtk-fb/cairo-fb
> without risking your dev environment, etc...
>
> Antoine



-- 
Inform me of my mistakes, so I can add them to my list!
Paolo Giarrusso, aka Blaisorblade
http://www.user-mode-linux.org/~blaisorblade
