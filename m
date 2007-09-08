Return-Path: <linux-kernel-owner+w=401wt.eu-S1752544AbXIHIiw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544AbXIHIiw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 04:38:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751424AbXIHIio
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 04:38:44 -0400
Received: from smtp-106-saturday.nerim.net ([62.4.16.106]:65221 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751370AbXIHIin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 04:38:43 -0400
Date: Sat, 8 Sep 2007 10:40:41 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Greg KH <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       David Brownell <david-b@pacbell.net>
Subject: Re: Platform device id
Message-ID: <20070908104041.4d8d1a24@hyperion.delvare>
In-Reply-To: <20070907205659.GA4357@khazad-dum.debian.net>
References: <20070907153559.17faf9d1@hyperion.delvare>
	<d120d5000709070758i1b54a37o3d3977304a84b2c1@mail.gmail.com>
	<20070907205659.GA4357@khazad-dum.debian.net>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Sep 2007 17:56:59 -0300, Henrique de Moraes Holschuh wrote:
> On 9/7/07, Jean Delvare <khali@linux-fr.org> wrote:
> > To go one step further, I am questioning the real value of this naming
> > exception for these "unique" platform devices. On top of the bugs I
> > mentioned above, it has potential for compatibility breakage: adding a
> 
> Agreed.  But the breakage might happen anyway, if you need to move
> attributes from foo.0 to foo.1.  After that first time, userspace will learn
> to hunt down all foo.* after what it wants, but still...

Moving attributes from one device to another? This doesn't make any
sense to me, sorry. foo.0 and foo.1 represent different instances of
the same device type, they typically have the same attributes.

-- 
Jean Delvare
