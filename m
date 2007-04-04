Return-Path: <linux-kernel-owner+w=401wt.eu-S1753967AbXDDStK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967AbXDDStK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 14:49:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753922AbXDDStI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 14:49:08 -0400
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:40787 "EHLO
	fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753915AbXDDStF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 14:49:05 -0400
Date: Wed, 4 Apr 2007 20:45:04 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Aaron Lehmann <aaronl@vitelus.com>, Jim Paris <jim@jtan.com>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: Silent corruption with r8169
Message-ID: <20070404184504.GB7814@electric-eye.fr.zoreil.com>
References: <20070401012736.GT15189@vitelus.com> <20070401030315.GA24080@jim.sh> <20070401043905.GV15189@vitelus.com> <p737iswqjq4.fsf@bingen.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p737iswqjq4.fsf@bingen.suse.de>
User-Agent: Mutt/1.4.2.1i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> :
> Aaron Lehmann <aaronl@vitelus.com> writes:
> 
> [adding netdev]
> [meta-comment: I wish people wouldn't use such unnecessarily broad subjects 
> -- how is it the x86-64 port's or AMD's fault when you have broken hardware? 
> Would anybody write "Silent corruption on i386" or "Silent corruption 
> on Intel" or "Silent corruption on Linux"?]

I hope you feel better now that I changed the subject.

Aaron, I see no clear suspect between 2.6.20.1 and current -git
that could explain nor fix a corruption in the r8169 driver.

Can you apply on top of latest 2.6.21-rc5-git the patches available at
http://www.fr.zoreil.com/linux/kernel/2.6.x/2.6.21-rc5/r8169-20070402

000[12]-r8169-foo-bar.patch have been committed a few minutes ago: you
should check if they apply or not.

netconsole appears compiled as a module. Is it used ?

-- 
Ueimor
