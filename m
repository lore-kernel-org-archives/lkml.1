Return-Path: <linux-kernel-owner+w=401wt.eu-S1755507AbYJWL4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507AbYJWL4S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 07:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751872AbYJWL4D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 07:56:03 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:41561 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbYJWL4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 07:56:01 -0400
From: Paul Moore <paul.moore@hp.com>
Organization: Hewlett-Packard
To: Tilman Baumann <tilman.baumann@collax.com>
Subject: Re: SMACK netfilter smacklabel socket match
Date: Thu, 23 Oct 2008 07:55:57 -0400
User-Agent: KMail/1.9.10
Cc: Casey Schaufler <casey@schaufler-ca.com>,
       "Linux-Kernel" <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org
References: <48DBC9A1.20900@collax.com> <48F8C3EC.1030607@collax.com> <48F8D122.3010105@schaufler-ca.com>
In-Reply-To: <48F8D122.3010105@schaufler-ca.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810230755.57819.paul.moore@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 17 October 2008 1:53:38 pm Casey Schaufler wrote:
> Tilman Baumann wrote:
> > Hi Casey,
> >
> > the last weeks I tried to come up with some way to circumvent my
> > problems by aimlessly poking around in the code. Did not work
> > though. Not yet at least. :)
> > Maybe it makes more sense for me to wait until you have a solution.
> > My whole project is stalled right now because of this and I'm not
> > sure what next.
> > Do you plan to change something there soon? If so I would stop
> > wasting my time with hopeless attempts.
> >
> > My problem is at the moment that I don't really know what to do. If
> > you can give some aim I would be glad if I could do something.
>
> Well, the good news is that I have a change under test that will
> address your needs, allowing a host or set of hosts to be generally
> accessible from the Smack system. The bad news is that it uses a set
> of netlabel apis that are not going to get released in favor of a
> redesigned set of apis which are not available yet. The good news is
> that those apis will handle Smack's needs just fine, but again the
> bad news is that I don't have them to use yet.

Just a quick update.  You can blame me for the delay, I was a bit 
distracted trying to get things ready for the 2.6.28 merge window and 
the NetLabel kernel API changes got pushed aside for a few weeks.  I 
just sent Casey a draft patch of the new API bits to review; with any 
luck I'll have something to post as an RFC patch shortly.

Thanks for your patience.

-- 
paul moore
linux @ hp
