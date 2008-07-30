Return-Path: <linux-kernel-owner+w=401wt.eu-S1754978AbYG3T2o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978AbYG3T2o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 15:28:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754046AbYG3T2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 15:28:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39720 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754025AbYG3T2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 15:28:33 -0400
Message-ID: <4890C09B.3000701@zytor.com>
Date: Wed, 30 Jul 2008 12:27:23 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Sam Ravnborg <sam@ravnborg.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       Jeff Dike <jdike@addtoit.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] x86: use arch/x86/include
References: <20080730124952.GA23413@uranus.ravnborg.org> <20080730180411.GA7896@elte.hu> <20080730184700.GA29710@uranus.ravnborg.org> <20080730191907.GD26389@elte.hu>
In-Reply-To: <20080730191907.GD26389@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> But fortunately you've scripted all this, so i guess we can do it at any 
> stage. Could you send the script we should run?
> 

That's really the sanest way to deal with all this.  If this is already 
automated, then we can script-generate a roving (constantly rebased) 
pseudo-branch, and apply it formally before pushing it up to Linus.

Restructuring changes are hideously messy, because they're orthogonal to 
everything else that's going on.  The x86 merge itself and all that went 
along with it is a great example.

	-hpa
