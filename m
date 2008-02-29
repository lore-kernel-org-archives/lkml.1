Return-Path: <linux-kernel-owner+w=401wt.eu-S1757373AbYB2Ho3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757373AbYB2Ho3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 02:44:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752283AbYB2HoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 02:44:18 -0500
Received: from sacred.ru ([62.205.161.221]:41770 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752201AbYB2HoR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 02:44:17 -0500
Message-ID: <47C7B7C3.4000504@openvz.org>
Date: Fri, 29 Feb 2008 10:44:03 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: serge@hallyn.com
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Alexey Dobriyan <adobriyan@openvz.org>,
       Linux Netdev List <netdev@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] Fix /proc/net in presence of net namespaces
References: <47C6D743.1050802@openvz.org> <m1y794514k.fsf@ebiederm.dsl.xmission.com> <20080228211720.GA1232@vino.hallyn.com>
In-Reply-To: <20080228211720.GA1232@vino.hallyn.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Fri, 29 Feb 2008 10:43:57 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Nack.  Yet another global set of ids that require us to implement another
>> namespace looks like the wrong way to go.
> 
> Sentiment granted, but I'm not sure it can be an issue.  It *could* be
> in issue if we moved to a more flexible access control here here any
> netns could access the .netns/N directories for all it's child
> namespaces.
> 
> But it can't, and /proc/net is set by the kernel.  So the <id> can't be
> an issue for any checkpoint/restart except htat of the whole system, and
> of course on whole-system resume we have no <id> collision worries.
> 
> So userspace can't do anything with <id>, so there is no reason to worry
> about it becoming another namespace?
> 
> Right?

Right. Thanks, Serge.

> thanks,
> -serge
