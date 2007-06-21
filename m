Return-Path: <linux-kernel-owner+w=401wt.eu-S1755421AbXFUS1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421AbXFUS1T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 14:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752422AbXFUS1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 14:27:08 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35825 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751862AbXFUS1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 14:27:06 -0400
Date: Thu, 21 Jun 2007 11:26:53 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Will Schmidt <will_schmidt@vnet.ibm.com>
cc: Olaf Hering <olaf@aepfle.de>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH for 2.6.22] [6/10] x86: Only make Macintosh drivers
 default on Macs
In-Reply-To: <1182448725.25426.19.camel@farscape.rchland.ibm.com>
Message-ID: <alpine.LFD.0.98.0706211125100.3593@woody.linux-foundation.org>
References: <200706201223.443613000@suse.de>  <20070620102334.DD01814AD0@wotan.suse.de>
  <20070621173628.GA21243@aepfle.de>
 <1182448725.25426.19.camel@farscape.rchland.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 21 Jun 2007, Will Schmidt wrote:
>
> I'll second that.  The obvious gotcha is that on a G5, the windfarm
> drivers don't get automatically selected, thus the fans run at full
> speed, and my office becomes a windtunnel. :-) 

Since when has "default" been anything but "default". It doesn't mean that 
you can't override it. And if "make oldconfig" doesn't take the _old_ 
setting into account over the new one, there's something wrong.

Of course, if there is no actual question, "default" ends up being what it 
always chosen (because no explicit choice is allowed), but in this case 
we're talking about:

	bool "Macintosh device drivers"

which definitely has that question.

		Linus
