Return-Path: <linux-kernel-owner+w=401wt.eu-S1755587AbZHMT5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587AbZHMT5n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 15:57:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755550AbZHMT5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 15:57:42 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38663 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754874AbZHMT5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 15:57:41 -0400
Date: Thu, 13 Aug 2009 20:58:48 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David VomLehn <dvomlehn@cisco.com>
Cc: linux-kernel@vger.kernel.org, greg@kroah.com, linux-usb@vger.kernel.org
Subject: Re: [PATCH] Combine two one-character CR-LF writes into one
 two-character write for O_ONLCR
Message-ID: <20090813205848.243c8569@lxorguk.ukuu.org.uk>
In-Reply-To: <20090813195554.GA22751@cuplxvomd02.corp.sa.net>
References: <20090813175430.GA8769@cuplxvomd02.corp.sa.net>
	<20090813205018.4d781c74@lxorguk.ukuu.org.uk>
	<20090813195554.GA22751@cuplxvomd02.corp.sa.net>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Works for me; please consider the patch withdrawn. I'll take a crack at fixing
> the generic serial driver the right way; if other drivers are doing mix-and-match
> with per-device code and generic code, they could get broken. I have no way to
> test for this, so I'm hoping others will help out.

I'll be happy to help test some of them and review the code. It was
always on the todo list to switch then to kfifo_*. 

Alan
