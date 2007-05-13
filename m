Return-Path: <linux-kernel-owner+w=401wt.eu-S1760460AbXEMWm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760460AbXEMWm1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 18:42:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755415AbXEMWmU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 18:42:20 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:42755 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755186AbXEMWmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 18:42:19 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46479440.3060305@s5r6.in-berlin.de>
Date: Mon, 14 May 2007 00:42:08 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070408 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Tilman Schmidt <tilman@imap.cc>
CC: "Robert P. J. Day" <rpjday@mindspring.com>,
       Bernd Eckenfels <ecki@lina.inka.de>, linux-kernel@vger.kernel.org
Subject: Re: undeprecate raw driver.
References: <E1HnHxK-0004CI-00@calista.eckenfels.net> <Pine.LNX.4.64.0705131347450.1144@localhost.localdomain> <464770A0.4070809@s5r6.in-berlin.de> <464787F4.8040708@imap.cc>
In-Reply-To: <464787F4.8040708@imap.cc>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tilman Schmidt wrote:
> Am 13.05.2007 22:10 schrieb Stefan Richter:
>> So why don't we simply say:
>>
>>   - "Users of feature A are urged to migrate to alternative B."
>>   - "Feature C will be removed in February 2038."
> 
> Because that's too long to add to a Kconfig tag line.
> You need a terse label there.

Then put "DEPRECATED" there, because you deprecate the enabling of the
option.

However, actual users of such a kernel option need the full explanation
of what's wrong with the option in order to decide whether to switch it
off.  The terse label alone is *insufficient*.   It's insufficient even
if you develop a scheme with two or more different labels for different
flavors of deprecation.  In fact, generically defined finer-grained
flavors of "deprecated" will be too fine-grained to be sensibly used in
/real/ feature removal processes.

It doesn't lead us anywhere to discuss about deprecation on an abstract
level.  Discuss concrete features (like the raw driver) with the people
who used that feature --- only then you get to know how to proceed with
that feature appropriately.
-- 
Stefan Richter
-=====-=-=== -=-= -===-
http://arcgraph.de/sr/
