Return-Path: <linux-kernel-owner+w=401wt.eu-S1761433AbXIJTol@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761433AbXIJTol (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 15:44:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761349AbXIJToY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 15:44:24 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45735 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761347AbXIJToX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 15:44:23 -0400
Date: Mon, 10 Sep 2007 21:44:21 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Prakash Punnoor <prakash@punnoor.de>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Why do so many machines need "noapic"?
Message-ID: <20070910194421.GA1819@one.firstfloor.org>
References: <46DF3BFF.9000809@redhat.com> <p73veao9gih.fsf@bingen.suse.de> <46E1A7B5.6000104@redhat.com> <200709080717.58271.prakash@punnoor.de> <46E59716.6020404@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46E59716.6020404@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Yes, it has an hpet. And I tried every combination of options I could
> think of.

> 
> But, even stranger, x86_64 works (only i386 fails.)

x86-64 has quite different time code (at least until the dyntick patches
currently in mm) 

Obvious thing would be to diff the boot messages and see if anything
jumps out (e.g. in interrupt routing).  

Or check with mm and if x86-64 is broken there too then it's likely
the new time code.

-Andi
