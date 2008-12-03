Return-Path: <linux-kernel-owner+w=401wt.eu-S1753419AbYLCMJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419AbYLCMJG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 07:09:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751849AbYLCMIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 07:08:54 -0500
Received: from one.firstfloor.org ([213.235.205.2]:50593 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790AbYLCMIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 07:08:53 -0500
Date: Wed, 3 Dec 2008 13:19:55 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Andi Kleen <andi@firstfloor.org>,
       x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: New location for generic headers?
Message-ID: <20081203121955.GJ6703@one.firstfloor.org>
References: <20081203003620.GA32069@basil.nowhere.org> <200812031140.02338.arnd@arndb.de> <20081203120110.GA2822@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081203120110.GA2822@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Should we try to get rid of all those silly:
> #include <asm-generic/foo.h>
> files we have in arch/$ARCH/include/asm?
> 
> We could for example add include/generic/ last in the search path.
> Or we could add the files in include/asm and add that last in the
> search path.
> 
> Then if we do not find <asm/foo.h> in arch/$ARCH/include/asm/
> then we search include/asm.

The only problem I see is that it would user space use of asm/ 
without make headers_install impossible. I suppose that could
break the setup of a lot of people? I think it would cause
problems on some of my older boxes at least.

-Andi
