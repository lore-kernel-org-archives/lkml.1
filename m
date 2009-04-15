Return-Path: <linux-kernel-owner+w=401wt.eu-S1759467AbZDOKwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759467AbZDOKwA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 06:52:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758813AbZDOKvr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 06:51:47 -0400
Received: from ozlabs.org ([203.10.76.45]:55473 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758777AbZDOKvp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 06:51:45 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: RFC: introduce struct ksymbol
Date: Wed, 15 Apr 2009 20:21:40 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: Joe Perches <joe@perches.com>, Sam Ravnborg <sam@ravnborg.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Tom Zanussi <tzanussi@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <1239753659-11790-1-git-send-email-fweisbec@gmail.com> <1239771791.32241.6.camel@localhost> <20090415055839.GA12040@elte.hu>
In-Reply-To: <20090415055839.GA12040@elte.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904152021.41427.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Apr 2009 03:28:39 pm Ingo Molnar wrote:
> Why not 'struct ksym'? That name is unused right now, it is shorter 
> and just as descriptive.
> 
> Regarding the change... dunno. Sam, Rusty - what do you think?

Yes, ksym is nice.  But agree with you that it's marginal obfuscation
to wrap it in a struct.

The current symbol printing APIs are awful; we should address them first
(like the %pF patch does) IMHO.

Cheers,
Rusty.
