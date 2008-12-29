Return-Path: <linux-kernel-owner+w=401wt.eu-S1754045AbYL2UgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045AbYL2UgS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 15:36:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753073AbYL2Ueg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 15:34:36 -0500
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:48175 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752626AbYL2Ue3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 15:34:29 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=djL+4o7pCTHhNtazwyRvCFPhr2ScJkAKKBmj6VO1CsEZCf0+QPZydQ9fpHj8WvpLeqJzVFqlIotRR4XJAR7efyBUkCgEowG6MsdjfkHFI9s0kfmT5h/RkqdozI1tslifwMkmPDBB9957GuKdx2/Q2D1TTu2vxmow7RheTPygQfE=  ;
X-YMail-OSG: MEBgfmcVM1ludab3BGJiyNM6fTlDiDjompxVIzXJRe6J0SRxRG2HlU0JmH2LCqr8TY4mZ4b6Wi27DLP_HSuSVtYkglrXH5wPixwQiZP_NviYg0s0G1PfJcSjcn9CNWIAsiIVvjSpm30iMDTFzn4Wexv.8NMllZ7gbSuQuRpnjafD276PGPa8EjS_4g62
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 10/13] drivers/usb/gadget: use USB API functions rather than constants
Date: Mon, 29 Dec 2008 12:22:48 -0800
User-Agent: KMail/1.9.10
Cc: Julia Lawall <julia@diku.dk>, gregkh@suse.de, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <Pine.LNX.4.44L0.0812291452580.1979-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0812291452580.1979-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812291222.48966.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 December 2008, Alan Stern wrote:
> On Mon, 29 Dec 2008, David Brownell wrote:
> 
> > Those functions were supposed to go into <linux/usb/ch9.h>, as
> > I recall, since they weren't specific to the host side stack.
> > 
> > Having them added to the wrong file is surely part of why
> > they've only been used by host side drivers.  :)
> 
> Would you like to write a patch moving the functions to ch9.h?  Or 
> would you like to ask Julia or me to do it?

Someone other than me.  ;)

Maybe someone on K-J will want to volunteer with a patch
before either you or Julia...

- Dave

