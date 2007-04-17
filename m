Return-Path: <linux-kernel-owner+w=401wt.eu-S1031295AbXDQXoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031295AbXDQXoA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 19:44:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031301AbXDQXoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 19:44:00 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:37976 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031295AbXDQXn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 19:43:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=m/waVgenuXnoYIEfVYH6SfzhRozdZEhOwfwrPBrLkwf3iWBCoG5wFeKBCR7sorA8XndDkyApSTh1SnwxxbgNhzZ8nuC0uGkz0aXUxsSPSI7Kd7qTTqVEkquTAvtcxpQwYk6whpOoDbK/j8L/gH/o0RpUqRlp4l2m/HnR6ALsItg=
Subject: Re: drivers/video/output.c
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, luming.yu@intel.com,
       greg@kroah.com, len.brown@intel.com
In-Reply-To: <20070417213716.GB7284@redhat.com>
References: <20070417213716.GB7284@redhat.com>
Content-Type: text/plain
Date: Wed, 18 Apr 2007 07:43:48 +0800
Message-Id: <1176853428.8463.6.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-04-17 at 17:37 -0400, Dave Jones wrote:
> commit 2dec3ba8d872aa3ffbcdb8f6f8a2c0bcd44e9910 puzzles me.
> 
> git-bisect just fingered it as responsible for my "backlight doesn't turn on"
> suspend/resume regression on the Thinkpad X60.  I think it's lying.
> 
> Why?  Because afaict, drivers/video/output.c is never compiled.
> That commit adds the driver, but doesn't touch any Makefile, and I
> don't see anything obvious in the follow-in commits that would 'enable' it.
> 
> Asides from git-bisect failing me again[1], what gives with this file?

Correct, it's basically dead code. Even if you compile it, but without
any users, it shouldn't do anything.

BTW, it's completely independent from framebuffer and backlight and I
doubt the commit is the cause of your problem.  

Tony



