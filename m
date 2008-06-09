Return-Path: <linux-kernel-owner+w=401wt.eu-S1760883AbYFILJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760883AbYFILJ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 07:09:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760150AbYFILJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 07:09:47 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46876 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759175AbYFILJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 07:09:46 -0400
Subject: Re: update checkpatch.pl to version 0.19
From: David Woodhouse <dwmw2@infradead.org>
To: Andy Whitcroft <apw@shadowen.org>
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-usb@vger.kernel.org
In-Reply-To: <20080609083301.GA6701@shadowen.org>
References: <200806061922.m56JMJuq025990@hera.kernel.org>
	 <20080606233037.GA8548@kroah.com>
	 <20080606230239.c1a8c002.akpm@linux-foundation.org>
	 <20080607173436.GA17603@kroah.com>  <20080609083301.GA6701@shadowen.org>
Content-Type: text/plain
Date: Mon, 09 Jun 2008 12:09:41 +0100
Message-Id: <1213009781.32207.615.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-06-09 at 09:33 +0100, Andy Whitcroft wrote:
> The issue I have is I have a comprehensive test suite which is kept in
> lock step with checkpatch itself, all in my own tree.  Now that is
> just noise for mainline.  What I want to be able to do is keep that in
> lock step with developments in my tree, but not merge it upstream.  So
> far I've not found a workable solution with git for that.

Why not make a tree which automatically tracks Linus' tree but only
includes checkpatch.pl. Then pull from that into your own tree before
you push your changes back.

-- 
dwmw2

