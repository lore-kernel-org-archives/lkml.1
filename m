Return-Path: <linux-kernel-owner+w=401wt.eu-S1761764AbZAOFE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761764AbZAOFE2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 00:04:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761409AbZAOFEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 00:04:08 -0500
Received: from mail.openmoko.org ([88.198.124.205]:34141 "EHLO
	mail.openmoko.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761386AbZAOFEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 00:04:06 -0500
Date: Thu, 15 Jan 2009 10:33:25 +0530
From: Balaji Rao <balajirrao@openmoko.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: David Miller <davem@redhat.com>, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org, andy@openmoko.com, sameo@openedhand.com,
       mingo@elte.hu, yinghai@kernel.org, akpm@linux-foundation.org,
       sfr@canb.auug.org.au
Subject: Re: pcf50663 MFD driver modular build failure
Message-ID: <20090115050324.GA3199@fedora.yogi>
References: <20090112.210501.215941396.davem@redhat.com> <20090113065159.GB3218@fedora.yogi> <20090114134712.6f0e430e.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090114134712.6f0e430e.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2009 at 01:47:12PM -0800, Randy Dunlap wrote:
> On Tue, 13 Jan 2009 12:22:02 +0530 Balaji Rao wrote:
> 
> > On Mon, Jan 12, 2009 at 09:05:01PM -0800, David Miller wrote:
> > > 
> > > This started happening with Linus's pull from today for
> > > sparc64 allmodconfig:
> > > 
> > > ERROR: "__set_irq_handler" [drivers/mfd/pcf50633-core.ko] undefined!
> > > ERROR: "handle_level_irq" [drivers/mfd/pcf50633-core.ko] undefined!
> > > 
> > > Sure we can export __set_irq_handler() and handle_level_irq() to
> > > modules to fix this, but that looks like some hokey stuff for
> > > a MFD driver to be doing :-)
> > 
> > Yes, right! It's really not necessary. I've sent a patch to remove it.
> 
> Who did you send the patch to and where is it in the queue??

Samuel has taken it into his linux-mfd tree and should be sending a pull
request real soon.

Thanks,
Balaji
