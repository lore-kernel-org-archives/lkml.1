Return-Path: <linux-kernel-owner+w=401wt.eu-S934053AbYBHJ4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934053AbYBHJ4d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 04:56:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760786AbYBHJ4Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 04:56:24 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54041 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760270AbYBHJ4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 04:56:23 -0500
Date: Fri, 8 Feb 2008 09:45:38 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Marcin Juszkiewicz <openembedded@haerwu.biz>,
       Christoph Hellwig <hch@infradead.org>, Greg KH <greg@kroah.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch/arm/Kconfig: Make UIO available on ARM architecture
Message-ID: <20080208094538.GC21852@flint.arm.linux.org.uk>
References: <20080207133805.13f092ff@dilbert.local> <20080207125824.GB7111@infradead.org> <20080207130117.GA18750@uranus.ravnborg.org> <200802071609.36960.openembedded@haerwu.biz> <20080207160557.GB28435@flint.arm.linux.org.uk> <20080207202329.GA21949@uranus.ravnborg.org> <1202461453.5469.217.camel@pmac.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1202461453.5469.217.camel@pmac.infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2008 at 09:04:13AM +0000, David Woodhouse wrote:
> On Thu, 2008-02-07 at 21:23 +0100, Sam Ravnborg wrote:
> > Both situations are trivially fixable by introducing
> > HAVE_IDE and HAVE_MTD.
> > See attached patch.
> 
> HAVE_MTD is wrong.

If we are serious about allowing ARM to use drivers/Kconfig, then let's
not get distracted by perfection - by trying to do too many changes in
one go.

If, today, we conditionalise MTD or IDE on a certain set of symbols,
then those conditions should be preserved in the first step - it should
be a 1:1 translation.

Later, if there's a need to improve it (as you're suggesting) that should
be a *separate* change.
