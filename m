Return-Path: <linux-kernel-owner+w=401wt.eu-S935062AbZDJK4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935062AbZDJK4Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 06:56:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764197AbZDJK4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 06:56:12 -0400
Received: from mail-gx0-f160.google.com ([209.85.217.160]:40219 "EHLO
	mail-gx0-f160.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762390AbZDJK4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 06:56:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Hel2kVXSZBT73BtH3ArTMMst3faWUOPE3jdeOeiT/ywTWIb7pxORbH6Kn3fjfDw0O6
         LQe/4lO8OkL5gw0ItuvWksRazeQ25n/e0Boyo9La1/wU0k5u12UFQkFHhqhuB4Bz4Ag1
         2yeLmvf0zm5NTwxCqkK8Se2WnJUC5H1oZONsI=
Subject: Re: 2.6.30-rc1: white screen during boot (regression) on spitz
From: Daniel Ribeiro <drwyrm@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Eric Miao <eric.y.miao@gmail.com>, rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>,
       Russell King <rmk@arm.linux.org.uk>, Dirk@opfer-online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       dbaryshkov@gmail.com, omegamoon@gmail.com
In-Reply-To: <f17812d70904100350l19fa7493ma9c4695d49d19398@mail.gmail.com>
References: <20090410103429.GA31367@elf.ucw.cz>
	 <f17812d70904100350l19fa7493ma9c4695d49d19398@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Apr 2009 07:56:07 -0300
Message-Id: <1239360967.14324.2.camel@brutus>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sex, 2009-04-10 às 18:50 +0800, Eric Miao escreveu:
> On Fri, Apr 10, 2009 at 6:34 PM, Pavel Machek <pavel@ucw.cz> wrote:
> > Hi!
> >
> > After update to 2.6.30-rc1, sharp zaurus c-3000 fails to boot with
> > white screen (with stripes). That's a regression w.r.t. 2.6.29.
> 
> What kind of white stripes? Does it look like the LCD controller
> stops working or something.
> 
> There is a regression which caused X server hang during bootup,
> with commit id 66c1ca0, which you can revert and have another
> try.

As spitz also use cs_control for pxa2xx_spi, i believe that this is the
same issue i found wednesday.

See the "Kernel freeze caused by
a7bb3909b3293d503211d7f6af8ed62c1644b686" thread.

-- 
Daniel Ribeiro

