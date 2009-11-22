Return-Path: <linux-kernel-owner+w=401wt.eu-S1755667AbZKVUvK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667AbZKVUvK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 15:51:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755649AbZKVUvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 15:51:09 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:49496 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755601AbZKVUvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 15:51:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rOzJqnq3+hiu+b3WaIRwPrF7qS3T5oR3K+doatzecJa3gj9dVG43xPvmIhk4BcD4KS
         0veoZs55dQ/Ja+AuyR970fXBzK1Ct4d919pf6jtAtX5Nyl7TLp7wCdwLLOesen8r0aFP
         ygHf9bAjGzFC5uPfJ8qtDl09UlgT81H0olLuQ=
Date: Sun, 22 Nov 2009 21:50:54 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: Caleb Cushing <xenoterracide@gmail.com>
Cc: Frans Pop <elendil@planet.nl>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: large packet loss take2 2.6.31.x
Message-ID: <20091122205054.GA7361@ami.dom.local>
References: <81bfc67a0911120546g26627ac5q5860d85f446b29bb@mail.gmail.com>
 <4AFC5C58.9030207@gmail.com>
 <81bfc67a0911130825o6d9b93b2he70677157ad889f2@mail.gmail.com>
 <20091113211640.GA2540@ami.dom.local>
 <81bfc67a0911180159g45a45675k44ce3f251c6bddea@mail.gmail.com>
 <20091118135136.GA9224@ff.dom.local>
 <81bfc67a0911181021n1b969565y4a39b181360b5e92@mail.gmail.com>
 <20091118201034.GA3060@ami.dom.local>
 <20091118223851.GA5191@ami.dom.local>
 <81bfc67a0911221135y300841f2i8e78417600528cd5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <81bfc67a0911221135y300841f2i8e78417600528cd5@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 22, 2009 at 02:35:10PM -0500, Caleb Cushing wrote:
> haven't had time to do a test yet. but would it be of any use for you
> all for me to throw another nic (it'd be a different driver for sure)
> in this box and test that on a problematic kernel? I have some but not
> with me.

Of course it would be useful. Especially if you find new bugs. ;-)
I'm not sure it's the fastest way to diagnose this problem, but if
it's not a problem for you...

Btw, currently I don't consider this dropping means there has to be
a bug. It could be otherwise - a feature... e.g. when a new kernel
can transmit faster (then dropping in some other, slower place can
happen).

Jarek P.

> 
> On Wed, Nov 18, 2009 at 5:38 PM, Jarek Poplawski <jarkao2@gmail.com> wrote:
> > On Wed, Nov 18, 2009 at 09:10:34PM +0100, Jarek Poplawski wrote:
> >> On Wed, Nov 18, 2009 at 01:21:19PM -0500, Caleb Cushing wrote:
> >> > yeah testing it under my known working config first. I'll get back w/ you later.
> >>
> >> Btw, since dropping at hardware (NIC) level seems more likely to me,
> >> could you send 'ethtool eth0', and 'ethtool -S eth0' after such tests
> >> (both sides).
> >
> > Hmm... and 'netstat -s' before and after the test (both sides).
> >
> > Jarek P.
> >
> 
> 
> 
> -- 
> Caleb Cushing
> 
> http://xenoterracide.blogspot.com
