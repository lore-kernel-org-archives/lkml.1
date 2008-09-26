Return-Path: <linux-kernel-owner+w=401wt.eu-S1753906AbYIZMf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906AbYIZMf2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 08:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751890AbYIZMfQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 08:35:16 -0400
Received: from mail.collax.com ([82.194.105.242]:59537 "EHLO mail.collax.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751719AbYIZMfP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 08:35:15 -0400
Message-ID: <48DCD700.7030706@collax.com>
Date: Fri, 26 Sep 2008 14:35:12 +0200
From: Tilman Baumann <tilman.baumann@collax.com>
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: Paul Moore <paul.moore@hp.com>
CC: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Casey Schaufler <casey@schaufler-ca.com>,
       linux-security-module@vger.kernel.org
Subject: Re: SMACK netfilter smacklabel socket match
References: <48DBC9A1.20900@collax.com> <200809251426.58179.paul.moore@hp.com>
In-Reply-To: <200809251426.58179.paul.moore@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Filtered: By ProxSMTP
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.33/RELEASE, bases: 26092008 #1128314, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Moore wrote:

> [NOTE: you may notice the above code changing slightly in future 
> kernels, it turns out that skb->sk == NULL is not a true indicator of a 
> non-local sender, see my labeled networking patches for 2.6.28 or 
> linux-next for the revised approach]

Can you give me a pointer where to look?

Will this mean that skb->sk may be invalid or that it will point to a a 
context based on the network label the packet has?
In the later case, being able to match remote labels in my match would 
just give added benefit. (Though a netlabel (CIPSO) match would probably 
be more sane than a smack specific match.)
One would just have more choices where to put a rule like this. Like in 
the FORWARD chain.
If non local packets are of no interest, one could put the rule in the 
right chain.

But i think i just misunderstood you here. Since having a socket for non 
local packets is probably not what you meant.

Regards
  Tilman
-- 
Tilman Baumann
Software Developer
Collax GmbH . Boetzinger Strasse 60 . 79111 Freiburg . Germany

p: +49 (0) 89-990157-0
f: +49 (0) 89-990157-11

Geschaeftsfuehrer: William K. Hite / Boris Nalbach
AG Muenchen HRB 158898, Ust.-IdNr: DE 814464942
