Return-Path: <linux-kernel-owner+w=401wt.eu-S1030944AbXDPUPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030944AbXDPUPU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 16:15:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030947AbXDPUPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 16:15:20 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:58487 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030944AbXDPUPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 16:15:18 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4623D94D.7040106@s5r6.in-berlin.de>
Date: Mon, 16 Apr 2007 22:15:09 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070408 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Bernd Eckenfels <ecki@lina.inka.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: ZFS with Linux: An Open Plea
References: <E1HdWld-0003oC-00@calista.eckenfels.net>
In-Reply-To: <E1HdWld-0003oC-00@calista.eckenfels.net>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bernd Eckenfels wrote:
> In article <4623BE2E.2020800@s5r6.in-berlin.de> you wrote:
>> I meant that the central requirement on the design and implementation of
>> audio subsystems is an (ideally guaranteed) bounded maximum of
>> latencies;
[...]
>> You were talking about throughput of storage systems, for which latencies
>> of the software part of the stack do not play such a central role.
[...]
> Unfortunatelle Latency is critical for a number of critical applications
> like databases or file based transaction systems (mail, news) - mainly the
> users of fsync().

Yes, I know that; and there may even be mass storage systems with actual
realtime requirements.  Note though that latencies in FUSE-based
filesystems due to (what do I know) context switches and possibly CPU
scheduling latencies are not necessarily relevant to the overall
latencies in applications which you mentioned.

Anyway, that's not at all what the original poster alluded to when he
made vague statements about FUSE vs. kernelspace filesystems, finishing
in the odd comparison with ALSA.

(Please try not to delete Ccs.)
-- 
Stefan Richter
-=====-=-=== -=-- =----
http://arcgraph.de/sr/
