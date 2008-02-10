Return-Path: <linux-kernel-owner+w=401wt.eu-S1758055AbYBJKq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758055AbYBJKq4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 05:46:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755940AbYBJKqq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 05:46:46 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:60292 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755593AbYBJKqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 05:46:45 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <47AED5A0.8040003@s5r6.in-berlin.de>
Date: Sun, 10 Feb 2008 11:44:48 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.11) Gecko/20071216 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Miles Lane <miles.lane@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Nishanth Aravamudan <nacc@us.ibm.com>, Adam Litke <agl@us.ibm.com>,
       David Gibson <david@gibson.dropbear.id.au>
Subject: Re: 2.6.24-git20 -- BUG: sleeping function called from invalid context
 at include/asm/uaccess_32.h:449
References: <a44ae5cd0802091103s4c24c70fyc747d9c4ab9a9897@mail.gmail.com>	<20080209162643.fd3822f1.akpm@linux-foundation.org> <20080209163812.704cf282@laptopd505.fenrus.org>
In-Reply-To: <20080209163812.704cf282@laptopd505.fenrus.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Sat, 9 Feb 2008 16:26:43 -0800
> Andrew Morton <akpm@linux-foundation.org> wrote:
>> Guys, how often mut it be said?  PLEASE always test all code with all
>> kernel deubg options enabled.
> 
> maybe we should make a CONFIG_KERNEL_DEVELOPER option that SELECTs the
> various options that really should be on.
> 
> If there is a chance of reasonable agreement on what those options are I'll cook
> up a patch...

There are a few in Documentation/SubmitChecklist items 12 and 15.

> (but I don't want to get bogged down in a 500 mail flamewar about
> CONFIG_FOO_BAR being right for this or not...)

You can be rather sure that there will be at least... questions and
concerns...  ;-)

Anyway, the root problem is that developers and integrators don't take
time to follow the rules in SubmitChecklist.  (I know that I still have
ways to go to improve my own processes in that regard.)  A Kconfig
switch may raise awareness of SubmitChecklist a little bit, but I'm
afraid it is not awareness what's the issue here.
-- 
Stefan Richter
-=====-==--- --=- -=-=-
http://arcgraph.de/sr/
