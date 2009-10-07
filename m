Return-Path: <linux-kernel-owner+w=401wt.eu-S1758861AbZJGLEJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758861AbZJGLEJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 07:04:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751094AbZJGLEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 07:04:08 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:64082 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931AbZJGLEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 07:04:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=EU2kp7EuU+DjhV/b291NQNpzqdo9EvvBbYxYI9mm18ojsna/oLsheEDpyOyeLOqUA8
         cy6wRdeXTT6919snegETaJbHIlWcppefuYx2PktXBxlbtZrrSd7GxAx0GJSF/KWutXo7
         yZGdQvUQoHP6HiMMLH2jUTJ4Dg1RXwXWQtdVI=
MIME-Version: 1.0
In-Reply-To: <661de9470910061610n53bd0de0gdeb8dec854ef679a@mail.gmail.com>
References: <63386a3d0910061406p32e514cdjbe6059e7af60fb87@mail.gmail.com>
	 <661de9470910061610n53bd0de0gdeb8dec854ef679a@mail.gmail.com>
Date: Wed, 7 Oct 2009 13:03:30 +0200
Message-ID: <63386a3d0910070403k1d1e6d56xa46d95d2ff448b2a@mail.gmail.com>
Subject: Re: CGFreak control group visualizer
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: linux kernel <linux-kernel@vger.kernel.org>,
       Jonathan Corbet <corbet@lwn.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/10/7 Balbir Singh <balbir@linux.vnet.ibm.com>:

> I looked at the screenshots and they look very interesting. Would it
> take a lot of effort to extend it to track other controllers like
> memory, network, etc?

No I don't think that'd be a problem if you can just come up with some
proper visualization idea.

Memory can probably be a piechart as well, representing the physical memory
(I think Matt already has some support for offline-generation of such charts in
smem but this could be interactive, on-the-fly.)

Network bandwidth is harder I think because I don't know how these interfaces
look if you want to measure throughput also (alottment would be easy to draw
as a pie chart).

Patches welcome :-)

Linus Walleij
