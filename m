Return-Path: <linux-kernel-owner+w=401wt.eu-S1753264AbXDDUGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264AbXDDUGo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 16:06:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753922AbXDDUGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 16:06:44 -0400
Received: from vitelus.com ([63.99.9.247]:36962 "EHLO vitelus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752347AbXDDUGm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 16:06:42 -0400
Date: Wed, 4 Apr 2007 13:06:04 -0700
From: Aaron Lehmann <aaronl@vitelus.com>
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: Andi Kleen <andi@firstfloor.org>, Jim Paris <jim@jtan.com>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: Silent corruption with r8169
Message-ID: <20070404200603.GX15189@vitelus.com>
References: <20070401012736.GT15189@vitelus.com> <20070401030315.GA24080@jim.sh> <20070401043905.GV15189@vitelus.com> <p737iswqjq4.fsf@bingen.suse.de> <20070404184504.GB7814@electric-eye.fr.zoreil.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070404184504.GB7814@electric-eye.fr.zoreil.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 04, 2007 at 08:45:04PM +0200, Francois Romieu wrote:
> > [adding netdev]
> > [meta-comment: I wish people wouldn't use such unnecessarily broad subjects 
> > -- how is it the x86-64 port's or AMD's fault when you have broken hardware? 
> > Would anybody write "Silent corruption on i386" or "Silent corruption 
> > on Intel" or "Silent corruption on Linux"?]
> 
> I hope you feel better now that I changed the subject.
> 
> Aaron, I see no clear suspect between 2.6.20.1 and current -git
> that could explain nor fix a corruption in the r8169 driver.
> 
> Can you apply on top of latest 2.6.21-rc5-git the patches available at
> http://www.fr.zoreil.com/linux/kernel/2.6.x/2.6.21-rc5/r8169-20070402
> 
> 000[12]-r8169-foo-bar.patch have been committed a few minutes ago: you
> should check if they apply or not.

I'll try to get to testing this, but I'm wondering if people may have
misunderstood my original post. I don't get any corruption over
Ethernet; it's just corruption on the filesystem during certain load
patterns that involve the Realtek ethernet card.

Aaron
