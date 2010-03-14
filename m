Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759468Ab0CNAe2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 19:34:28 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:41049 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759405Ab0CNAe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 19:34:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=gZGV0SwFWMYseaQHIIBp7VnHl1W7rl33riU6PUAW0iuDmippOTQPyk+5UkBBQLNmjs
         g0TGkxd18i7XCEwQ9CdYpMmuwxBj7MzFGJ4dtDM0CyTwHFELw8HMK+rnq+nHQ6XHPGMA
         tZgaWcKCdngYj2lIYnOPQnxKxVSQQM3EUl93Q=
Date: Sat, 13 Mar 2010 16:34:25 -0800
From: 640E9920 <640e9920@gmail.com>
To: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       dwalker@codeaurora.org, tiwai@suse.de, bruce.w.allan@intel.com,
       aili@codeaurora.org, khilman@deeprootsystems.com, pavel@ucw.cz,
       mgross@linux.intel.com
Subject: [PATCH] PM_QOS updates for 2.6.34-rc1
Message-ID: <20100314003425.GA17812@mgross-acer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch series implements to following:
1) pm_qos now uses a handle based implementation.  No more string
compares while walking lists.
2) renames the exports to using more accurate names.
3) updates kernel clients of pm_qos per this change
4) added ascii interface to pmqos recognizing strings formatted in 10
charactor format "0x12345678"
5) added new pm_qos class, "system_bus_throughput"

I would like to see this series make it into 2.6.34 if its not too late. 

I was able to test it on my laptop and comments welcome.

Thank you!

--mgross
