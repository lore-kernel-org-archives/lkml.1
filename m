Return-Path: <linux-kernel-owner+w=401wt.eu-S932204AbZGOSY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932204AbZGOSY7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 14:24:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755348AbZGOSY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 14:24:58 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:35152 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755229AbZGOSY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 14:24:58 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4A5E1D1A.3090705@s5r6.in-berlin.de>
Date: Wed, 15 Jul 2009 20:16:58 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.22) Gecko/20090630 SeaMonkey/1.1.17
MIME-Version: 1.0
To: dedekind@infradead.org
CC: Subrata Modak <subrata@linux.vnet.ibm.com>, linux-mtd@lists.infradead.org,
       Adrian Hunter <adrian.hunter@nokia.com>,
       Sachin P Sant <sachinp@linux.vnet.ibm.com>,
       David Howells <dhowells@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 02/06] Fix compilation warning for fs/ubifs/commit.c
References: <20090715021901.4112.45973.sendpatchset@subratamodak.linux.ibm.com> <1247640750.11353.6.camel@localhost.localdomain>
In-Reply-To: <1247640750.11353.6.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Artem Bityutskiy wrote:
> On Wed, 2009-07-15 at 07:49 +0530, Subrata Modak wrote:
>> Following fix is inspired by David Howells fix few days back:
>> http://lkml.org/lkml/2009/7/9/109,
>>
>> Signed-off-by: Subrata Modak<subrata@linux.vnet.ibm.com>,
>> ---
> 
> Removed junk comma at the end of "signed-off-by" and pushed to
> the ubifs-2.6.git tree:
> 
> http://git.infradead.org/ubifs-2.6.git?a=commit;h=5c1507e6097c4abc13bbad69de137366c9043f22
> 
> Thanks.
> 

The changelog of the patch is bad.  "Fix compilation warning" is not 
correct.  It should be "suppress compilation warning" or "annotate 
unitialized variable" or whatever --- i.e. it should say what it does. 
Furthermore, since the 3 lines context around the change in the diff do 
not reveal why the chosen "fix" is correct and desirable, the changelog 
should also leave a note why it's done this way.

The patch form David Howells which is quoted here has an equally bad 
subject, but at least its changelog goes on to explain what the patch 
really does and why it does it in the proposed way.
-- 
Stefan Richter
-=====-==--= -=== -====
http://arcgraph.de/sr/
