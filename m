Return-Path: <linux-kernel-owner+w=401wt.eu-S1758674AbXIGU5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758674AbXIGU5S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 16:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758428AbXIGU5H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 16:57:07 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:36646 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758420AbXIGU5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 16:57:06 -0400
X-Sasl-enc: 9d+e3+ulyExLghPDdNGKdcVLf/R/7EbRpv36AThiMxJ3 1189198623
Date: Fri, 7 Sep 2007 17:56:59 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jean Delvare <khali@linux-fr.org>, Greg KH <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       David Brownell <david-b@pacbell.net>
Subject: Re: Platform device id
Message-ID: <20070907205659.GA4357@khazad-dum.debian.net>
References: <20070907153559.17faf9d1@hyperion.delvare> <d120d5000709070758i1b54a37o3d3977304a84b2c1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d120d5000709070758i1b54a37o3d3977304a84b2c1@mail.gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 Sep 2007, Dmitry Torokhov wrote:
> On 9/7/07, Jean Delvare <khali@linux-fr.org> wrote:
> > To go one step further, I am questioning the real value of this naming
> > exception for these "unique" platform devices. On top of the bugs I
> > mentioned above, it has potential for compatibility breakage: adding a

Agreed.  But the breakage might happen anyway, if you need to move
attributes from foo.0 to foo.1.  After that first time, userspace will learn
to hunt down all foo.* after what it wants, but still...

> If a device has a <name>.<instance> scheme this implies possibility of
> having several instances of said device in a box. There are a few of

No, it doesn't. It allows for, but it does not imply anything.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
