Return-Path: <linux-kernel-owner+w=401wt.eu-S1753526AbYIBGLP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526AbYIBGLP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 02:11:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752237AbYIBGK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 02:10:58 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:33267 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002AbYIBGK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 02:10:57 -0400
Message-ID: <4b0be9b641de902cb7de4ad50686f6e1.squirrel@secure.sipsolutions.net>
In-Reply-To: <1220319536.28282.128.camel@debian.sh.intel.com>
References: <20080901160658.GA11063@google.com>
    <1220319536.28282.128.camel@debian.sh.intel.com>
Date: Tue, 2 Sep 2008 08:10:09 +0200 (CEST)
Subject: Re: new: regression iwl3945/mac80211 endless after suspend 
     associate/deassociate loop
From: "Johannes Berg" <johannes@sipsolutions.net>
To: "Zhu Yi" <yi.zhu@intel.com>
Cc: "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "LKML" <linux-kernel@vger.kernel.org>, reinette.chatre@intel.com,
       linux-wireless@vger.kernel.org,
       "Jan-Espen Pettersen" <sigsegv@radiotube.org>,
       "John W. Linville" <linville@tuxdriver.com>
User-Agent: SquirrelMail/1.4.15
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
X-sips-origin: local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zhu Yi wrote:
> On Mon, 2008-09-01 at 19:07 +0300, Michael S. Tsirkin wrote:
>> [16482.909453] eth1: associate with AP XX:XX:XX:XX:XX:XX
>> [16482.918553] eth1: RX ReassocResp from XX:XX:XX:XX:XX:XX
>> (capab=0x411 status=0 aid=1)
>> [16482.918564] eth1: associated
>> [16492.920224] eth1: disassociating by local choice (reason=3)
>> [16492.920986] eth1: disassociating by local choice (reason=3)
>
> It is exactly 10 seconds the local STA sends the deauth_leaving frame
> before associated everytime. I wonder if it is the timeout for some
> wireless config tools. NM?

"by local choice" means wext requested this, not a kernel bug.

johannes

