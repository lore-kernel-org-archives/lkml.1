Return-Path: <linux-kernel-owner+w=401wt.eu-S1753920AbZI3B3F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920AbZI3B3F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 21:29:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753827AbZI3B3E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 21:29:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40202 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753816AbZI3B3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 21:29:03 -0400
Date: Tue, 29 Sep 2009 18:27:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: uclinux-dist-devel@blackfin.uclinux.org, chrisv@cyberswitching.com,
       linux-kernel@vger.kernel.org, michael.hennerich@analog.com
Subject: Re: [Uclinux-dist-devel] [PATCH] ad525x_dpot: new driver for AD525x
  digital potentiometers
Message-Id: <20090929182746.245afa74.akpm@linux-foundation.org>
In-Reply-To: <8bd0f97a0909291814l2de1f989lcf640633cf25b9c8@mail.gmail.com>
References: <1253161357-22453-1-git-send-email-vapier@gentoo.org>
	<20090929153902.ab74aa01.akpm@linux-foundation.org>
	<8bd0f97a0909291814l2de1f989lcf640633cf25b9c8@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Sep 2009 21:14:37 -0400 Mike Frysinger <vapier.adi@gmail.com> wrote:

> > + __ __ __ if (reg & AD525X_REG_TOL)
> > + __ __ __ __ __ __ __ return sprintf(buf, "0x%04x\n", value & 0xFFFF);
> > + __ __ __ else
> > + __ __ __ __ __ __ __ return sprintf(buf, "%u\n", value & data->rdac_mask);
> >
> > which makes me suspect that the proposed userspace interface is quite
> > poor.
> 
> not really.

Think so.  We have a sysfs file which under some circumstances will
return a decimal number and which under others will return a hex
number.  So userspace is supposed to look for the leading 0x to work
out how to interpret that number?

Or something.  Whatever.  Perhaps it all makes sense when one has seen
the overall description.

