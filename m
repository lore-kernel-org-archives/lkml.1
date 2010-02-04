Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757525Ab0BDLNi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 06:13:38 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:3043 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755403Ab0BDLNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 06:13:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:subject:from:reply-to:to:cc:in-reply-to:references
         :content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=dxEjyQh1f20CABYzF6+S/0HuENGTjxpZgFOJKO+1arErwaMdQWhpHggXhiOWxBqEHj
         Idt54RBJCXUjEcRoDVypT9+FmTbFoB6cPKdwh9OiavzVM+5jE9sR4UJKAdb6OL1+djUp
         pJfgnRazNAStU/eazkSTSUdETUdDsbvuTEEbQ=
Subject: Re: patch net-restore-ip-source-validation.patch added to
 2.6.32-stable tree
From: jamal <hadi@cyberus.ca>
Reply-To: hadi@cyberus.ca
To: Stefan Lippers-Hollmann <s.L-H@gmx.de>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, davem@davemloft.net,
       stable@kernel.org
In-Reply-To: <201002032114.59960.s.L-H@gmx.de>
References: <1265060041850@kroah.org>  <201002032114.59960.s.L-H@gmx.de>
Content-Type: text/plain
Date: Thu, 04 Feb 2010 06:13:31 -0500
Message-Id: <1265282011.4204.12.camel@bigi>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

I am downloading 2.6.32-7 to see if i can reproduce it. My gut is
telling me it will be hard to see in my setup.
Can you try to see if it something in your boot initialization i.e with
no init e.g something like init=/bin/sh and then initcall_debug?

cheers,
jamal

On Wed, 2010-02-03 at 21:14 +0100, Stefan Lippers-Hollmann wrote:

> 
> This patch, as part of the current 2.6.32 stable queue, breaks booting with
> an oops very early, before the framebuffer got a chance to initialize 
> (unfortunately most of it is cut with the unavoidable vga=0, so I didn't 
> write it down yet), on amd64 and i386 (kernel configs attached). Removing
> just this patch from queue-2.6.32 fixes the problem for me; kernel 2.6.33 
> HEAD doesn't seem to be affected.
> 

> Regards
> 	Stefan Lippers-Hollmann
> 

