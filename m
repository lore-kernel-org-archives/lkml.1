Return-Path: <linux-kernel-owner+w=401wt.eu-S933593AbXBXX2O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933593AbXBXX2O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 18:28:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933592AbXBXX2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 18:28:14 -0500
Received: from nz-out-0506.google.com ([64.233.162.237]:32777 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933593AbXBXX2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 18:28:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=tP4AVsjkQVTJtlRmmxTUxNXU0jMi9FYx+xZxQmkhzYl9RyTc0U1K+21HfOL2iR1IChKFQtNJ7ey0osMRFQCwiZmAJYKlaEA9psaw0bupmIDcsQd8D8PzK4xKOQ5lo0NHaP+6puRK0gZme6pm8KJZXBLN2hqZFOrIikQ3bndxCeE=
Subject: Re: 2.6.21-rc1: framebuffer/console boot failure
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Andrew Nelless <andrew@nelless.net>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
In-Reply-To: <33525.86.7.220.119.1172358010.squirrel@wmbeta.mxes.net>
References: <35472.86.7.220.119.1172237750.squirrel@wmbeta.mxes.net>
	 <20070224030950.074f88d4.akpm@linux-foundation.org>
	 <33525.86.7.220.119.1172358010.squirrel@wmbeta.mxes.net>
Content-Type: text/plain
Date: Sun, 25 Feb 2007 07:30:42 +0800
Message-Id: <1172359843.4415.8.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-02-24 at 23:00 +0000, Andrew Nelless wrote:
> On Sat, February 24, 2007 11:09 am, Andrew Morton wrote:
> >
> > Presumably this regression was caused by the ACPI merge.  Are you able to
> > capture the dmesg output from the 2.6.20-rc1 boot?  netconsole might be useful here, thanks.
> >
> 
> I've confirmed a few things:
> 
> 1) 2.6.21-rc1 actually will boot intermittently.
> 2) pci=noacpi always allows 2.6.21-rc1 to boot.
> 2) 2.6.20 always boots.
> 3) There doesn't seem to be a pattern (that I can tell) between booting and not booting,
> although it'll now boot more often than not (It seemed very much t'other way around yesterday)
> 4) When 2.6.21-rc1 doesn't boot ('Boot'? Am i using the right term here? hmm...) nothing is
> sent across netconsole at all.
> 5) Netconsole is useful.
> 
> I've uploaded all the dmesg output i've managed to capture here:
> http://homepage.ntlworld.com/anelless/linux/2.6.21-rc1/
> 
> > (You get added to the post-2.6.20 regression list, so you'll be hearing
> > from us quite a lot for the next month.  Sorry ;))
> >
> 
> Lucky me :)

How about booting with just vga=normal?

Tony


