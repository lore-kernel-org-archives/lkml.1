Return-Path: <linux-kernel-owner+w=401wt.eu-S965844AbXIJWpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965844AbXIJWpx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 18:45:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965757AbXIJWpo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 18:45:44 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:57709 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965116AbXIJWpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 18:45:43 -0400
X-Sasl-enc: NJaxIZTInQs08v8tDKp5Qa2rSsXWVEi4QksEfZDLt/t3 1189464347
Date: Mon, 10 Sep 2007 19:45:38 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Jean Delvare <khali@linux-fr.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Greg KH <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       David Brownell <david-b@pacbell.net>
Subject: Re: Platform device id
Message-ID: <20070910224537.GA1408@khazad-dum.debian.net>
References: <20070907153559.17faf9d1@hyperion.delvare> <d120d5000709070758i1b54a37o3d3977304a84b2c1@mail.gmail.com> <20070907205659.GA4357@khazad-dum.debian.net> <20070908104041.4d8d1a24@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070908104041.4d8d1a24@hyperion.delvare>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 08 Sep 2007, Jean Delvare wrote:
> On Fri, 7 Sep 2007 17:56:59 -0300, Henrique de Moraes Holschuh wrote:
> > On 9/7/07, Jean Delvare <khali@linux-fr.org> wrote:
> > > To go one step further, I am questioning the real value of this naming
> > > exception for these "unique" platform devices. On top of the bugs I
> > > mentioned above, it has potential for compatibility breakage: adding a
> > 
> > Agreed.  But the breakage might happen anyway, if you need to move
> > attributes from foo.0 to foo.1.  After that first time, userspace will learn
> > to hunt down all foo.* after what it wants, but still...
> 
> Moving attributes from one device to another? This doesn't make any
> sense to me, sorry. foo.0 and foo.1 represent different instances of
> the same device type, they typically have the same attributes.

Yeah, I came across that need in an attempt to fix an issue in thinkpad-acpi
which will be fixed in another way (separate modules, or separate platform
devices/platform drivers in the same module).  I must have been
sleep-deprieved and in a weird mind state of sorts (and not in a nice way)
to come up with it.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
