Return-Path: <linux-kernel-owner+w=401wt.eu-S1761160AbYCSUiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761160AbYCSUiT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757912AbYCSTmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:42:08 -0400
Received: from one.firstfloor.org ([213.235.205.2]:50919 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757849AbYCSTlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:41:53 -0400
Date: Tue, 18 Mar 2008 18:20:45 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH prototype] [0/8] Predictive bitmaps for ELF executables
Message-ID: <20080318172045.GI11966@one.firstfloor.org>
References: <20080318209.039112899@firstfloor.org> <20080318003620.d84efb95.akpm@linux-foundation.org> <20080318141828.GD11966@one.firstfloor.org> <20080318095715.27120788.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080318095715.27120788.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> What's the permission problem?  executable-but-not-readable files?  Could

Not writable. 

> be handled by passing your request to a suitable-privileged server process,
> I guess.

Yes it could, but i dont even want to thi nk about all the issues of
doing such an interface. It is basically an microkernelish approach.
I prefer monolithic simplicity.

e.g. i am pretty sure your user space implementation would be far
more complicated than a nicely streamlined kernel implementation. 
And I am really not a friend of unnecessary complexity. In the end
complexity hurts you, no matter if it is in ring 3 or ring 0.

-Andi
