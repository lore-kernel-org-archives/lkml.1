Return-Path: <linux-kernel-owner+w=401wt.eu-S937857AbXG0USq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937857AbXG0USq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 16:18:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934546AbXG0USf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 16:18:35 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:62339 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934165AbXG0USe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 16:18:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LIrdIGbdwKTAOSuLTibJxMkgYhjgTsL3sCfARxtGMSYB++gE5fL1ItopxKfy44yGXuNZ4wBSgarsVGNv9q0CwKeQVgBf9UrL9v+IX0cRsMIGScPVEqwFAQaHUtlZnJ/1VUrsgpjzO+Rw6E+mrZP9SZ7oJgtWRqC4yqwLKeqbJV8=
Message-ID: <92a12cdb0707271318t141ee32bs69cb9dab22eabba2@mail.gmail.com>
Date: Fri, 27 Jul 2007 21:18:33 +0100
From: "Adrian McMenamin" <adrianmcmenamin@gmail.com>
To: "Antonino A. Daplas" <adaplas@gmail.com>
Subject: Re: Problems with framebuffer in 2.6.22-git17
Cc: "Adrian McMenamin" <lkmladrian@gmail.com>, linux-kernel@vger.kernel.org,
       lethal@users.sourceforge.net
In-Reply-To: <92a12cdb0707271247s727993b8i33999a9652b2ca20@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <92a12cdb0707221141i4398d6fdxa7994c5f1f809b0a@mail.gmail.com>
	 <1185146563.6370.8.camel@daplas>
	 <8b67d60707241445l2764d9f1odb72848342135048@mail.gmail.com>
	 <1185406433.5046.23.camel@daplas>
	 <92a12cdb0707271247s727993b8i33999a9652b2ca20@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/07/07, Adrian McMenamin <adrianmcmenamin@gmail.com> wrote:

> With the patch reverted and 24bpp, it oopses before freezing (with two
> odd looking boot logos on the screen):
>
Tested this further and it fails on:

rev = fb_readl(par->mmio_base + 0x04);

Will try to see what's up - but if anyone knows what is likely to be
wrong here please shout out!
