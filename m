Return-Path: <linux-kernel-owner+w=401wt.eu-S1754508AbYKTHyy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508AbYKTHyy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 02:54:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753592AbYKTHyp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 02:54:45 -0500
Received: from mtagate1.de.ibm.com ([195.212.17.161]:44040 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149AbYKTHyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 02:54:44 -0500
Message-ID: <492517BC.3050205@fr.ibm.com>
Date: Thu, 20 Nov 2008 08:54:36 +0100
From: Daniel Lezcano <dlezcano@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Michael Kerrisk <mtk.manpages@googlemail.com>
CC: Pavel Emelyanov <xemul@openvz.org>, David Miller <davem@davemloft.net>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       lkml <linux-kernel@vger.kernel.org>, linux-man@vger.kernel.org,
       Subrata Modak <subrata@linux.vnet.ibm.com>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       adobriyan@gmail.com, Patrick McHardy <kaber@trash.net>, den@openvz.org
Subject: Re: Current state of Network Namespaces (NETNS, CLONE_NEWNET)?
References: <492489D1.5080502@gmail.com>
In-Reply-To: <492489D1.5080502@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Kerrisk wrote:
> Sorry for the shotgun mail, but in the end,  it's
> not clear who can best answer my question(s).
> 
> I'm currently trying to add documentation of all of
> the undocumented CLONE_* flags.  One of these is
> CLONE_NEWNET, and I could use (quite a lot of) help.  
> 
> My questions:
> 
> What is the current state of the network namespace 
> implementation?  Is it complete?  

It is not complete but mostly usable for ipv4 and ipv6.

There is a network namespace status I filled at:

http://lxc.sourceforge.net/network/status.php

It should be up-to-date.

> What objects are considered part of the network 
> namespace, and therefore distinct for a new network 
> namespace?

The network namespace brings isolation from the layer-2 to upper layers.

> Is there any documentation for network namespaces 
> already?

http://lxc.sourceforge.net/network.php
http://lxc.sourceforge.net/doc/sigops/appcr.pdf

> Are there any test programs for network namespaces?

http://sourceforge.net/projects/lxc/

follow the README page. It is still in development but mainly usable  - 
any feedbacks are welcome :)

