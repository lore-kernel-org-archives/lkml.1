Return-Path: <linux-kernel-owner+w=401wt.eu-S1753406Ab0A1MTg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406Ab0A1MTg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 07:19:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752842Ab0A1MTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 07:19:35 -0500
Received: from stinky.trash.net ([213.144.137.162]:47928 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972Ab0A1MTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 07:19:34 -0500
Message-ID: <4B6180D1.6050609@trash.net>
Date: Thu, 28 Jan 2010 13:19:29 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: Jon Masters <jonathan@jonmasters.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>, netfilter-devel@vger.kernel.org
Subject: Re: PROBLEM: reproducible crash KVM+nf_conntrack all recent 2.6 kernels
References: <1264657559.2793.103.camel@tonnant> <1264658364.2793.105.camel@tonnant>
In-Reply-To: <1264658364.2793.105.camel@tonnant>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jon Masters wrote:
> On Thu, 2010-01-28 at 00:46 -0500, Jon Masters wrote:
> 
>> A number of people seem to have reported this crash in various forms,
>> but I have yet to see a solution, and can reproduce on 2.6.33-rc5 this
>> evening so I know it's still present in the latest upstream kernels too.
>> Userspace is Fedora 12, and this happens on both all recent F12 kernels
>> (sporadic in 2.6.31 until recently, solidly reproducible on 2.6.32) and
>> upstream 2.6.32, and 2.6.33-rc5 also - hard to find a "known good".
> 
> Now I can capture the panic()s, I'm rebuilding the 2.6.33-rc5 kernel
> with some better debugging options to at least get some more data.

Could you try "ip6tables -t raw -I PREROUTING -j TRACE" after loading
the ip6t_LOG module? That way we can hopefully see the entire packet
paths through netfilter.
