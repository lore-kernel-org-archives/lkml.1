Return-Path: <linux-kernel-owner+w=401wt.eu-S1753811AbZJ0RSd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811AbZJ0RSd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 13:18:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752032AbZJ0RSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 13:18:32 -0400
Received: from relais.videotron.ca ([24.201.245.36]:18787 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbZJ0RSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 13:18:32 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Tue, 27 Oct 2009 13:18:34 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Sam Ravnborg <sam@ravnborg.org>,
       LKML <linux-kernel@vger.kernel.org>, "Luck, Tony" <tony.luck@intel.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Robert Richter <robert.richter@amd.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Jean Delvare <khali@linux-fr.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [RFC] to rebase or not to rebase on linux-next
In-reply-to: <1256657956.26028.408.camel@gandalf.stny.rr.com>
Message-id: <alpine.LFD.2.00.0910271258160.10545@xanadu.home>
References: <4AE19A74.1090709@garzik.org> <20091023123555.GA25366@elte.hu>
 <57C9024A16AD2D4C97DC78E552063EA3E33D0174@orsmsx505.amr.corp.intel.com>
 <20091023134115.GD27097@elte.hu>
 <alpine.LFD.2.00.0910231424440.21460@xanadu.home>
 <20091023191631.GA1879@elte.hu>
 <1256326512.26028.34.camel@gandalf.stny.rr.com>
 <20091023205400.GA8356@elte.hu> <20091023215958.GA4139@merkur.ravnborg.org>
 <1256599588.26028.340.camel@gandalf.stny.rr.com>
 <20091027075954.GA32640@elte.hu>
 <1256657956.26028.408.camel@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Oct 2009, Steven Rostedt wrote:

> Sure, but I'm not talking about changing the patch, I'm talking about a
> late "reviewed by" or "tested-by". These usually do come after a patch
> set has been moved into the final git push. It would be nice to flag a
> commit that it was tested by someone.
>
[...]
> 
> My suggestion is to add an "annotation" commit that can tag another
> commit with something like a "tested-by". This way a tester can say,
> they tested this particular commit, and if someone changes it, the SHA1
> will no longer match. And then we can also have a record of what commit
> was tested by who, after the fact that it went into git.

There is a "git notes" feature from Johan Herland being carried in thepu 
branch of the git repository.  I strongly suggest to those who might 
think this could be useful in this context to express their interest by 
posting to git@vger.kernel.org.  With a concrete need and usage scenario 
(and offer to help at least with testing) this feature might become 
usable sooner.


Nicolas
