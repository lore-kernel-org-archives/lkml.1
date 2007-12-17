Return-Path: <linux-kernel-owner+w=401wt.eu-S934199AbXLQQKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934199AbXLQQKf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 11:10:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758713AbXLQQKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 11:10:19 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:51364 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758447AbXLQQKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 11:10:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=fd7xs4KQswVN5BZ5Jd65zMebinXnP71rvczOseTsSgYAXooyd7AJgygkEuDP9K0mw3gf+7Kr0pO9PPf09yJPXuRGMXc4JK97gepe8MY+tTCWCYo8e30dHIWi64H6pIUYft1ZY9a57bnk64o9o56HbZnbYlYrmAxvCCvOZD5yDfg=
Date: Mon, 17 Dec 2007 19:10:08 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jan Beulich <jbeulich@novell.com>, tglx@linutronix.de,
       Andrew Morton <akpm@linux-foundation.org>, mingo@redhat.com,
       linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [PATCH] x86-64: make pda's cpunumber and nodenumber unsigned
Message-ID: <20071217161008.GC7882@cvg.cvg>
References: <47610530.76E4.0078.0@novell.com> <20071217132619.GB1870@elte.hu> <476689AF.76E4.0078.0@novell.com> <20071217145317.GD16604@elte.hu> <20071217153445.GB7882@cvg.cvg> <20071217160127.GB30958@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071217160127.GB30958@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Mon, Dec 17, 2007 at 05:01:27PM +0100]
| 
| * Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| 
| > Checkpatch still does complain about
| > 	if (0) { T__ tmp__; tmp__ = (val)
| > I'm not sure if we need this line at all.
| 
| that's a type-checking trick. It does not result in any generated code 
| but gcc flags it with a build time warning if there's a type mismatch. 
| So it's a checkpatch.pl false positive.
| 
| 	Ingo
| 

Thanks Ingo!

I'll fetch up the tree you mentoined in prev letter and next time
try to be more carefull with patches I'm sending (i'm a bit busy
with my second machine on which i'm trying to install fc8 but
anaconda hangs again and again so that is the reason I'm not sync'ed
with x86 and mm trees yet, sorry)

		Cyrill

