Return-Path: <linux-kernel-owner+w=401wt.eu-S1756893AbXITOKH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756893AbXITOKH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 10:10:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753123AbXITOJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 10:09:57 -0400
Received: from one.firstfloor.org ([213.235.205.2]:52787 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754767AbXITOJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 10:09:56 -0400
Date: Thu, 20 Sep 2007 16:09:54 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: arch/x86_64/kernel/Makefile: why EXTRA_AFLAGS := -traditional
Message-ID: <20070920140954.GI18707@one.firstfloor.org>
References: <200709201501.44009.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200709201501.44009.vda.linux@googlemail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2007 at 03:01:43PM +0100, Denys Vlasenko wrote:
> Hi Andi,
> 
> arch/x86_64/kernel/Makefile has 
> 
> EXTRA_AFLAGS := -traditional
> 
> and this is causing me trouble with #define MACRO(a,b) a.b
> (defined in one of included header file).
> It expands incorrectly, as "a. b" - extra space.
> 
> If I use a.##b, all other .S files suffer - I am getting
> a.##b expansion in them.
> 
> Can I remove EXTRA_AFLAGS := -traditional?

Inherited long ago from i386. Does it build without it?
If yes it's ok to remove.

-Andi
