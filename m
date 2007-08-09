Return-Path: <linux-kernel-owner+w=401wt.eu-S938946AbXHIHyi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938946AbXHIHyi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 03:54:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938007AbXHIHyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 03:54:23 -0400
Received: from ns1.suse.de ([195.135.220.2]:52150 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936872AbXHIHyR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 03:54:17 -0400
Date: Thu, 9 Aug 2007 00:19:32 -0700
From: Greg KH <gregkh@suse.de>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
       linux-kernel@vger.kernel.org, "Hans J. Koch" <hjk@linutronix.de>
Subject: Re: [PATCH 2/3] UIO: Documentation
Message-ID: <20070809071932.GA22318@suse.de>
References: <20070718232332.GA4620@kroah.com> <11848012053678-git-send-email-gregkh@suse.de> <11848012122374-git-send-email-gregkh@suse.de> <9a8748490708081436g23c8f01cga585d6612b380f16@mail.gmail.com> <14166.1186611154@turing-police.cc.vt.edu> <9a8748490708081603k65746311sad595947fd5ab971@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a8748490708081603k65746311sad595947fd5ab971@mail.gmail.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2007 at 01:03:39AM +0200, Jesper Juhl wrote:
> >
> I think the only way to avoid it is to not provide something like UIO.

Problem is, things like UIO provide a real solution for a wide range of
different types of devices.  Like the one provided in the kernel right
now, and a bunch of others that I am currently discussing with different
manufacturers (think high-speed DSPs that just want to give userspace
direct access to the card and have the kernel get the hell out of the
way so data can be read and processed as fast as possible.)

And also realize that some types of systems have been doing this very
same kind of kernel/userspace interface for many years, namely X :)

As for the legalities of using closed source userspace code with the UIO
interface, consult a lawyer if you have questions, and be sure to bring
up Alan's comments about derivative works :)

thanks,

greg k-h
