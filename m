Return-Path: <linux-kernel-owner+w=401wt.eu-S1756883AbZLURGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883AbZLURGR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 12:06:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756771AbZLURGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 12:06:09 -0500
Received: from mail-gx0-f211.google.com ([209.85.217.211]:35685 "EHLO
	mail-gx0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756907AbZLURGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 12:06:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=lxuA3gir5Ae/6hscJKBPFQ7Ttq/9yKohyzzHET0pBWZmu3nI42IUfcODb3YABVtPXc
         bsCtaRomuSyzP6sbneFunG54+VzB/k7L6dZ9uNY5enZb/zZRVk9miIfXw/wS//6zSr6s
         YzTw1oKcOJDYiwf3mYM1x48URI+piY3s6yWho=
MIME-Version: 1.0
In-Reply-To: <20091221164619.GA27521@suse.de>
References: <1261413668-30145-1-git-send-email-vapier@gentoo.org> 
	<20091221164619.GA27521@suse.de>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 21 Dec 2009 12:05:40 -0500
Message-ID: <8bd0f97a0912210905s1a9512ffp45bf77555b3685df@mail.gmail.com>
Subject: Re: [PATCH] Driver core: export platform_device_register_data as a 
	GPL symbol
To: Greg KH <gregkh@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Michael Hennerich <michael.hennerich@analog.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 21, 2009 at 11:46, Greg KH wrote:
> On Mon, Dec 21, 2009 at 11:41:08AM -0500, Mike Frysinger wrote:
>> This allows MFD's to register/bind drivers for their sub devices while
>> still being compiled as a module.
>
> Is this a problem that we need to get resolved in .33, or older kernels,
> or just for .34?

the functionality is in place now, so it could be used in .33.  but it
isnt that big of a deal to simply say the mfd core cant be built as a
module right now.

so, it'd be nice for .33, but if it's too much hassle, .34 is OK.
-mike
