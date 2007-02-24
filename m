Return-Path: <linux-kernel-owner+w=401wt.eu-S932743AbXBXOlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932743AbXBXOlo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 09:41:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932750AbXBXOlo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 09:41:44 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:52624 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932743AbXBXOlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 09:41:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=rwT/LjK6ld4QcTveNzYzIoFzu/Y6zI9H25Nx3L/afp1Vg2ZdO2K/FKnl2JBA4d78NoZ+IIDGoohwOZjAZXHMqoPc0ibFBIcNVBjGjVs2wxKW1KZQ+KmdwAGwx636oiFid/S2dkpVL7Dr2Qa3UyTtmxXoVeyHVgu4N+DXlGiTG6k=
Date: Sat, 24 Feb 2007 17:38:48 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Oleg Verych <olecom@flower.upol.cz>
Cc: linux-kernel-list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] USB Elan FTDI: check for workqueue creation v2
Message-ID: <20070224143848.GA10148@cvg>
References: <20070224074115.GB10139@cvg> <E1HKwIW-0005OS-Nw@flower>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1HKwIW-0005OS-Nw@flower>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 24, 2007 at 01:46:44PM +0100, Oleg Verych wrote:
| > From: Cyrill Gorcunov
| > Newsgroups: gmane.linux.kernel
| > Subject: bss zeroing ([PATCH] USB Elan FTDI: check for workqueue creation v2)
| > Date: Sat, 24 Feb 2007 10:41:15 +0300
| []
| > Btw, Pete, you are right! C99 ANSI standart says that static pointer
| > if it not initialized explicitly has to be set to NULL by compiler ;)
| > Thanks a lot for comments and Ack the patch please.
| 
| Are you sure about "by compiler"? I mean, why not by OS, in case of uCs
| by code/data memory image generator?
| 
| ____
| 

I don't think that is the point... C compiler may put that data to a
special section of image (which is to be filled by zero) or add a few
explicit instructions... I don't care the method for a while, I need
the result ;)

		Cyrill

