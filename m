Return-Path: <linux-kernel-owner+w=401wt.eu-S1756467AbYHHASl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756467AbYHHASl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 20:18:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753775AbYHHASd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 20:18:33 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:37700 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430AbYHHASc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 20:18:32 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <489B90B0.5070303@s5r6.in-berlin.de>
Date: Fri, 08 Aug 2008 02:17:52 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.16) Gecko/20080722 SeaMonkey/1.1.11
MIME-Version: 1.0
To: mkrufky@linuxtv.org
CC: khali@linux-fr.org, sam@ravnborg.org, user.kernel@gmail.com,
       linux-kernel@vger.kernel.org, i2c@lm-sensors.org
Subject: Re: Problem with restricted I2C algorithms in kernel 2.6.26!
References: <489B6A66.40605@linuxtv.org>
In-Reply-To: <489B6A66.40605@linuxtv.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mkrufky@linuxtv.org wrote:
> With the model that you propose, "use linux-next for development" ... 
> well then what about testing?  Who is going to test my driver if it 
> requires a full kernel compile?

We almost _never_ use linux-next in the way that we base our development 
on it.  We use it to prepare integration.


BTW, looking back at this thread in the list archive, I see some people 
thoroughly confusing
   - unmerged code,
   - external developer repositories/ external patchkits,
   - module source files outside a complete kernel source directory.
These are all independent matters.

All code starts as unmerged code.
All developers use external repositories.

However, module source files which are outside of the kernel source 
directory are not quite the norm.  (Because the kernel build system 
doesn't support this.)
-- 
Stefan Richter
-=====-==--- =--- -=---
http://arcgraph.de/sr/
