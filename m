Return-Path: <linux-kernel-owner+w=401wt.eu-S1754236AbZEYKoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236AbZEYKoT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 06:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752964AbZEYKoD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 06:44:03 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:57054 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571AbZEYKoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 06:44:01 -0400
Message-ID: <4A1A7659.6060201@s5r6.in-berlin.de>
Date: Mon, 25 May 2009 12:43:37 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.21) Gecko/20090303 SeaMonkey/1.1.15
MIME-Version: 1.0
To: Matthias Schwarzott <zzam@gentoo.org>
CC: linux-hotplug@vger.kernel.org, Christian Kujau <lists@nerdbynature.de>,
       linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
       netdev@vger.kernel.org
Subject: Re: [PATCH] ieee1394: eth1394: use "firewire%d" instead of "eth%d"
 as interface name
References: <tkrat.21c425cc195510c9@s5r6.in-berlin.de> <alpine.DEB.2.01.0905232309400.7424@bogon> <tkrat.6c3758bf0544a790@s5r6.in-berlin.de> <200905251033.09272.zzam@gentoo.org>
In-Reply-To: <200905251033.09272.zzam@gentoo.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthias Schwarzott wrote:
> On Sonntag, 24. Mai 2009, Stefan Richter wrote:
>> Besides, if we can we should avoid fw%d because this will clash with
>> udev rules which match KERNEL=="fw*", as in
>> udev/rules/redhat/40-redhat.rules.
> 
> I suggest a subsystem match here, or generally some
> SUBSYSTEM!="net", GOTO="end_of_file"
> around almost all rule files that should not match on network interfaces, as 
> users can rename them to almost all crazy names.
> 
> @Kay: Perhaps it could simplify some rulesets to have a special jump target or 
> option to skip entiere rules files.

Right...  Luckily, 75-persistent-net-generator.rules already has a big
SUBSYSTEM!="net", GOTO="persistent_net_generator_end" around everything.

Also, "fw*" devices related rules which I'll submit RSN will have
SUBSYSTEM=="firewire" prefixes.
-- 
Stefan Richter
-=====-==--= -=-= ==--=
http://arcgraph.de/sr/
