Return-Path: <linux-kernel-owner+w=401wt.eu-S1754392AbZFDJy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754392AbZFDJy0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 05:54:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751181AbZFDJyS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 05:54:18 -0400
Received: from n22a.bullet.mail.mud.yahoo.com ([68.142.207.188]:39064 "HELO
	n22a.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751107AbZFDJyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 05:54:17 -0400
X-Greylist: delayed 370 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Jun 2009 05:54:17 EDT
X-Yahoo-Newman-Id: 836652.3816.bm@omp402.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=I7lFrrwAFpMeo3rLFCQgI6uw7gIdFi8a7hjCbDeli9ASWr+gvYmSPv8an52EouEUwzRGgGquiu2Vexbvbdz6YHH5wUyZpNo7o0mgSmsLJf09TlHyrTeDgUugzMY3zFtG/vZWluJDMLP+mV9PMh2TEAFFEvCyvmUVmxRZtoAw4fY=  ;
X-YMail-OSG: B.HtUv4VM1lVZNH_qq4j0GQtC_7NN.ZrHjFhh.f6_Ncoe_JkmjstChtzfc4vm4rN9kp.b.rXW0igN1A8G5MM.d9iXGBiPC1Pam0zW4S5X55O69jxFuHh28zxptYv6BKeFLZBVRQwfakzMXNIXLpvaLBTOSgUI.QoryQ7iGB4Hl0FKeliQlUZtz0at4KcE95IKlEEkElRzEwGIfaDHwlamtIPX4AIC0BanJPCW6fkDel.OLrGrZQ0PJ7_2pLDx4XnpJ9HDJ3VlFVu8_g-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [PATCH] gpio sysfs: add a "toggle" value
Date: Thu, 4 Jun 2009 02:48:07 -0700
User-Agent: KMail/1.9.10
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <1244017019-28163-1-git-send-email-vapier@gentoo.org> <200906040215.48264.david-b@pacbell.net> <8bd0f97a0906040220k6f56b944n733a2b3469faaccb@mail.gmail.com>
In-Reply-To: <8bd0f97a0906040220k6f56b944n733a2b3469faaccb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200906040248.07922.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 June 2009, Mike Frysinger wrote:
> > I don't like the idea of embedding any kind of interpreter
> > in the sysfs interface, but that's the direction you seem
> > to be heading ...
> 
> i dont view the userspace GPIO interface as a simple "i want to wiggle
> pins for fun and testing".  i see it as a dynamic method for building
> userspace drivers for simple devices.

I don't.  I see it as an adjunct to real drivers.  Or maybe
we just differ on what "simple" means here.


> as such, having a very simple 
> "command language" for optimizing the interaction provides a pretty
> good trade off between kernel complexity and lowering overhead imo.

If that's what you want, why don't you write a custom driver
that provides the kind of command interpreter you want?

