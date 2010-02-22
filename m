Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292Ab0BVQG1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 11:06:27 -0500
Received: from alternativer.internetendpunkt.de ([88.198.24.89]:56443 "EHLO
	geheimer.internetendpunkt.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754259Ab0BVQG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 11:06:26 -0500
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [net-next PATCH v4 1/3] net: TCP thin-stream detection
MIME-Version: 1.0
Date: Mon, 22 Feb 2010 17:06:25 +0100
From: Hagen Paul Pfeifer <hagen@jauu.net>
Cc: Lars Eggert <lars.eggert@nokia.com>, David Miller <davem@davemloft.net>,
       <zimmermann@nets.rwth-aachen.de>, <pavel@ucw.cz>, <apetlund@simula.no>,
       <netdev@vger.kernel.org>, <ilpo.jarvinen@helsinki.fi>,
       <eric.dumazet@gmail.com>, <Arnd.Hannemann@nets.rwth-aachen.de>,
       <linux-kernel@vger.kernel.org>, <shemminger@vyatta.com>,
       <william.allen.simpson@gmail.com>, <damian@tvk.rwth-aachen.de>,
       <ebiederm@xmission.com>
In-Reply-To: <87k4u5mh9u.fsf@basil.nowhere.org>
References: <20100221102102.GB1311@ucw.cz> <D40945A6-301D-485D-BB8C-826D2EB68DA4@nets.rwth-aachen.de> <2EC47E8B-BC4C-4DAB-86ED-F702D67F8AD0@nokia.com> <20100221.150311.193707249.davem@davemloft.net> <FB5F656F-091A-4FB5-9586-15C6CB263D05@nokia.com> <87k4u5mh9u.fsf@basil.nowhere.org>
Message-ID: <228e2e29ccd24144a77d42cfc5bc72fa@localhost>
User-Agent: RoundCube Webmail/0.1-rc1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="UTF-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 22 Feb 2010 16:17:33 +0100, Andi Kleen <andi@firstfloor.org> wrote:
> Lars Eggert <lars.eggert@nokia.com> writes:
> 
>> If it's off by default there is no issue.
> 
> Still a sufficient large number of people might turn it on
> and then the network would melt.

Then we should apply the same policy as used for the congestion control
algorithms!? Restrict the usage to change the standard behavior via Kconfig
(e.g. menuconfig TCP_CONG_ADVANCED) or even more restricted demand for
CAP_NET_ADMIN.

Hagen



