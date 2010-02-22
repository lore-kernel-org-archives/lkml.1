Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103Ab0BVPfv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 10:35:51 -0500
Received: from mta-2.ms.rz.RWTH-Aachen.DE ([134.130.7.73]:63607 "EHLO
	mta-2.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754081Ab0BVPfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 10:35:48 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
X-IronPort-AV: E=Sophos;i="4.49,518,1262559600";   d="scan'208";a="46009440"
Subject: Re: [net-next PATCH v4 1/3] net: TCP thin-stream detection
From: Alexander Zimmermann <Alexander.Zimmermann@nets.rwth-aachen.de>
In-reply-to: <87k4u5mh9u.fsf@basil.nowhere.org>
Date: Mon, 22 Feb 2010 16:35:49 +0100
Cc: Lars Eggert <lars.eggert@nokia.com>, David Miller <davem@davemloft.net>,
       "pavel@ucw.cz" <pavel@ucw.cz>,
       "apetlund@simula.no" <apetlund@simula.no>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "ilpo.jarvinen@helsinki.fi" <ilpo.jarvinen@helsinki.fi>,
       "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>,
       Arnd Hannemann <Arnd.Hannemann@nets.rwth-aachen.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "shemminger@vyatta.com" <shemminger@vyatta.com>,
       "william.allen.simpson@gmail.com" <william.allen.simpson@gmail.com>,
       "damian@tvk.rwth-aachen.de" <damian@tvk.rwth-aachen.de>,
       "ebiederm@xmission.com" <ebiederm@xmission.com>
Message-id: <2114B7CA-8078-4D90-BEFA-91956C58B6DA@nets.rwth-aachen.de>
References: <20100221102102.GB1311@ucw.cz>
 <D40945A6-301D-485D-BB8C-826D2EB68DA4@nets.rwth-aachen.de>
 <2EC47E8B-BC4C-4DAB-86ED-F702D67F8AD0@nokia.com>
 <20100221.150311.193707249.davem@davemloft.net>
 <FB5F656F-091A-4FB5-9586-15C6CB263D05@nokia.com>
 <87k4u5mh9u.fsf@basil.nowhere.org>
To: Andi Kleen <andi@firstfloor.org>
X-Mailer: Apple Mail (2.1077)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Am 22.02.2010 um 16:17 schrieb Andi Kleen:

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

100% ack.

See for example here: http://www.umic-mesh.net/~zimmermann/linux.png

It's a screenshot of the ps3mediaserver. Since it's a streaming server, it's
very useful to deactivate Nagle :-)

Alex

> 
> -- 
> ak@linux.intel.com -- Speaking for myself only.

//
// Dipl.-Inform. Alexander Zimmermann
// Department of Computer Science, Informatik 4
// RWTH Aachen University
// Ahornstr. 55, 52056 Aachen, Germany
// phone: (49-241) 80-21422, fax: (49-241) 80-22220
// email: zimmermann@cs.rwth-aachen.de
// web: http://www.umic-mesh.net
//

