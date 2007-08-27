Return-Path: <linux-kernel-owner+w=401wt.eu-S1762733AbXH0QWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762733AbXH0QWs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 12:22:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762135AbXH0QTx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 12:19:53 -0400
Received: from host-66-43-248-10 ([67.55.143.10]:34117 "EHLO albrecht.rdi1.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762304AbXH0QTu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 12:19:50 -0400
Subject: Re: coldplug zd1211rw wireless driver results in firefox segfault
From: Paul Albrecht <albrecht@rdi1.com>
To: Greg KH <greg@kroah.com>
Cc: Paul Albrecht <albrecht@rdi1.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20070825013808.GA24439@kroah.com>
References: <1187986902.24891.12.camel@albrecht.rdi1.com>
	 <20070825013808.GA24439@kroah.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 27 Aug 2007 11:23:44 -0400
Message-Id: <1188228224.800.2.camel@albrecht.rdi1.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-08-24 at 18:38 -0700, Greg KH wrote:
> On Fri, Aug 24, 2007 at 04:21:42PM -0400, Paul Albrecht wrote:
> > Hi,
> > 
> > I'm trying to use a hawking hwu54g with the zd1211rw driver in the
> > 2.6.20 linux kernel. It works ok when I hotplug the device, but causes
> > firefox to segfault when I coldplug the device.
> > 
> > As I get the segfault whether or not I bring the device up, I'm
> > wondering if there's a problem with the usb subsystem initialization.
> > 
> > Any ideas? Please cc me because I don't usually subscribe to the lkml.
> 
> Can you try a newer kernel?  That driver has gotten a lot of work in the
> past 6 months.

Tried 2.6.21 and that worked. Thanks.

Paul Albrecht
