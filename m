Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026Ab0BVPkd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 10:40:33 -0500
Received: from mail.2750.no ([62.101.244.198]:54101 "EHLO mail.2750.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753770Ab0BVPkb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 10:40:31 -0500
Message-ID: <4B82A566.5000600@simula.no>
Date: Mon, 22 Feb 2010 16:40:22 +0100
From: Andreas Petlund <apetlund@simula.no>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9pre) Gecko/20100217 Shredder/3.0.3pre
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Lars Eggert <lars.eggert@nokia.com>, David Miller <davem@davemloft.net>,
       "zimmermann@nets.rwth-aachen.de" <zimmermann@nets.rwth-aachen.de>,
       "pavel@ucw.cz" <pavel@ucw.cz>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "ilpo.jarvinen@helsinki.fi" <ilpo.jarvinen@helsinki.fi>,
       "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>,
       "Arnd.Hannemann@nets.rwth-aachen.de" 
	<Arnd.Hannemann@nets.rwth-aachen.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "shemminger@vyatta.com" <shemminger@vyatta.com>,
       "william.allen.simpson@gmail.com" <william.allen.simpson@gmail.com>,
       "damian@tvk.rwth-aachen.de" <damian@tvk.rwth-aachen.de>,
       "ebiederm@xmission.com" <ebiederm@xmission.com>
Subject: Re: [net-next PATCH v4 1/3] net: TCP thin-stream detection
References: <20100221102102.GB1311@ucw.cz>	<D40945A6-301D-485D-BB8C-826D2EB68DA4@nets.rwth-aachen.de>	<2EC47E8B-BC4C-4DAB-86ED-F702D67F8AD0@nokia.com>	<20100221.150311.193707249.davem@davemloft.net>	<FB5F656F-091A-4FB5-9586-15C6CB263D05@nokia.com> <87k4u5mh9u.fsf@basil.nowhere.org>
In-Reply-To: <87k4u5mh9u.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22. feb. 2010 16:17, Andi Kleen wrote:
> Lars Eggert <lars.eggert@nokia.com> writes:
> 
>> If it's off by default there is no issue.
> 
> Still a sufficient large number of people might turn it on
> and then the network would melt.
> 
> IMHO TCP changes with badly understood congestion behaviour
> should not be merged until the necessary analysis/simulation etc.
> is done.
> 
> -Andi

Graphs from our experiments can be found here:
http://simula.no/research/nd/publications/Simula.nd.477/simula_pdf_file

Section 5.2.5 covers experiments on fairness-issues. We have found no
adverse effects of the modifications submitted in this patch set (mFR
and LT in the plot), but further testing cannot hurt.

Best regards,
Andreas
