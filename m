Return-Path: <linux-kernel-owner+w=401wt.eu-S1753822AbYIXXBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822AbYIXXBS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 19:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752034AbYIXXBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 19:01:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55708 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751882AbYIXXBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 19:01:07 -0400
Date: Wed, 24 Sep 2008 16:00:27 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Frans Pop <elendil@planet.nl>
cc: linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       tglx@tglx.de, mingo@elte.hu
Subject: Re: Warning/Oops report of the week of September 16th, 2008
In-Reply-To: <alpine.LFD.1.10.0809241541320.3265@nehalem.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0809241559100.3265@nehalem.linux-foundation.org>
References: <20080916092206.6342c498@infradead.org> <200809250036.47277.elendil@planet.nl> <alpine.LFD.1.10.0809241541320.3265@nehalem.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 24 Sep 2008, Linus Torvalds wrote:
> 
> Or rather, it's a warnign about the parport /proc interface. The fact is, 
> the parport code can generate multiple "instances" of things that 
> time-slice on the port, but they have all ended up always just registering 
> under the same name. IOW, it's a bug in the _user_ interface, not the 
> kernel.

Side note: the reason nobody cares is that the files exported there are 
likely never used anyway. But we don't _know_ that. Maybe somebody depends 
on the totally broken things that get registered in /proc. I doubt it, 
but..

		Linus
