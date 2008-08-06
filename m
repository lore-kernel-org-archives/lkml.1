Return-Path: <linux-kernel-owner+w=401wt.eu-S1758748AbYHFIP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758748AbYHFIP7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 04:15:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756256AbYHFIPq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 04:15:46 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:39234 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756138AbYHFIPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 04:15:45 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <48995D9F.4010900@s5r6.in-berlin.de>
Date: Wed, 06 Aug 2008 10:15:27 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.16) Gecko/20080722 SeaMonkey/1.1.11
MIME-Version: 1.0
To: jmerkey@wolfmountaingroup.com
CC: Masami Hiramatsu <mhiramat@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.27-rc1-git5 2/26] mdb: correct kprobes int3 trap
References: <200808050626.m756QZ1g003755@wolfmountaingroup.com>    <489872C5.2040508@redhat.com> <39379.166.70.238.45.1217950104.squirrel@webmail.wolfmountaingroup.com>
In-Reply-To: <39379.166.70.238.45.1217950104.squirrel@webmail.wolfmountaingroup.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jmerkey@wolfmountaingroup.com wrote on 2008-08-05:
> I was unaware of checkpatch.pl, but will run it later today and submit a
> git6 patch for any areas not in compliance with linux coding standards.

I guess you got complaints from scripts/checkpatch.pl for at least 3/4 
of all lines by now.  Some or many of the complaints will probably look 
silly.  Have a look at Documentation/CodingStyle then because it gives 
context for many of the complaints.  It also gives some rules of thumb 
for things which checkpatch.pl cannot check, e.g. legibility of global 
names.

 From what I saw, there are _many_ whitespace "deviations" in your code 
(which perhaps scripts/Lindent can help to adjust), upper case vs. lower 
case in names, and occasional functions which are deeper nested than 
probably necessary, as already mentioned.
-- 
Stefan Richter
-=====-==--- =--- --==-
http://arcgraph.de/sr/
