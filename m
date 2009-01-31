Return-Path: <linux-kernel-owner+w=401wt.eu-S1753140AbZAaLTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140AbZAaLTS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 06:19:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751188AbZAaLTG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 06:19:06 -0500
Received: from nn7.de ([85.214.94.156]:38374 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930AbZAaLTF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 06:19:05 -0500
Subject: Re: 2.6.29-rc3+git macbook pro1,1 garbled display on resume
From: Soeren Sonnenburg <kernel@nn7.de>
To: "Justin P\. Mattock" <justinmattock@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <4983F365.40701@gmail.com>
References: <1233348609.3707.6.camel@localhost>  <4983F365.40701@gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Sat, 31 Jan 2009 12:18:59 +0100
Message-Id: <1233400739.4140.3.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-30 at 22:44 -0800, Justin P. Mattock wrote:
> Soeren Sonnenburg wrote:
> > Hi,
> >
> > the macbook pro suspends just fine, but even though the machine returns
> > to X I see on resume some random garbled output but can still move the
> > mouse cursor (which is OK!) and using the keyboard successfully adjust
> > the brightness of the display.
[...]
> Same here with jaunty i.g.
> one week it worked then the next it didn't.
> maybe disabling hotplug with xorg.conf
> might make the keys work.

I recognized that everything seems to work just fine *on console only*.
At least I could suspend and resume via s2ram >3 times in a row.

What also worked was to just start plain X (no window manager or
anything) and suspend/resume then. However with compiz running I am
seeing the garbage/hang on resume.

Are you by chance to having an ATI card + use a compositing window
manager?

Soeren
