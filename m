Return-Path: <linux-kernel-owner+w=401wt.eu-S1755555AbYKEWUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555AbYKEWUn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 17:20:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752265AbYKEWU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 17:20:29 -0500
Received: from swm.pp.se ([212.247.200.143]:44497 "EHLO uplift.swm.pp.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751060AbYKEWU2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 17:20:28 -0500
Date: Wed, 5 Nov 2008 23:20:25 +0100 (CET)
From: Mikael Abrahamsson <swmike@swm.pp.se>
To: Daniel J Blueman <daniel.blueman@gmail.com>
cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux Netdev <netdev@vger.kernel.org>,
       Linux Networking <linux-net@vger.kernel.org>
Subject: Re: time for TCP ECN defaulting to on?
In-Reply-To: <6278d2220811040632u7a36d68ekad5de517fd0671bb@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0811052316210.10993@uplift.swm.pp.se>
References: <6278d2220811040632u7a36d68ekad5de517fd0671bb@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
Organization: People's Front Against WWW
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Nov 2008, Daniel J Blueman wrote:

> Is it time to enable TCP ECN per default and get the benefits, since 
> router support has been around and known-about for really considerable 
> time?

I think enabling ECN by default is a bad idea.

Looking at the largest core router vendor out there:

http://www.cisco.com/en/US/docs/ios/12_2t/12_2t8/feature/guide/ftwrdecn.html#wp1031751

ECN has to actually be turned on in the routers along the way, it's not 
default behaviour. No ISP I know of does this, but I can do a poll of 
other ISP engineers in case more information is wanted.

So the upside of enabling it is minimal (I'd gladly see data proving the 
opposite) and the downside is a lot of trouble with lots of older devices 
which behave badly when ECN is enabled.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
