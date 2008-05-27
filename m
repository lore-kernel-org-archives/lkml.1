Return-Path: <linux-kernel-owner+w=401wt.eu-S1759686AbYE0Vc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759686AbYE0Vc1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 17:32:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758500AbYE0VcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 17:32:16 -0400
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:47787 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758548AbYE0VcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 17:32:15 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=4BnZc1fQeYOtgD87PQj/HNB8kxzannEow5SDZlZF21AuSK1fdAZEnV+cJvk2wDY/eZ+qel/ySfTV5YV5djH1NhtyTshPeamMBwAiAYJPKiE26qdSB+0J8+m9eH1hgsVn8HwDS2NrW3dNBzex4BAlZfxqN1tGz8bZLFUWW+dJf50=  ;
X-YMail-OSG: V2KdYRIVM1nH7AynkRdo3aBK.mHWm1Ejji0sqLiO.UfoBI17ERMslb8RNb9Pd5gLVeKe.JmDJ4bbgsCYOub89.Njk9TOSRCpASmInr.6Gl5F8pvIy1q3mvrRNpq6oZvztnE-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Tobias Diedrich <ranma+kernel@tdiedrich.de>
Subject: Re: [PATCH 0/4] Fix forcedeth hibernate/wake-on-lan problems
Date: Tue, 27 May 2008 14:32:12 -0700
User-Agent: KMail/1.9.9
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ayaz Abdulla <aabdulla@nvidia.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
References: <20080518125715.GA19229@yamamaya.is-a-geek.org> <20080525181329.GA5044@yamamaya.is-a-geek.org> <20080527062153.GA3651@yamamaya.is-a-geek.org>
In-Reply-To: <20080527062153.GA3651@yamamaya.is-a-geek.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200805271432.12881.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 26 May 2008, Tobias Diedrich wrote:
> The platform_enable_wakeup() hook is still there, but unused.

The patches to support it (still) haven't been merged.


> AFAICS this patch should solve the "'ethtool -s eth0 wol g' doesn't
> suffice, I also have to write magic values into /proc/acpi/wakeup"
> issue.

Yeah; under ACPI, PCI does not act like it does everywhere else.
Nor does wakeup in general.

After sending patches to fix that for a couple years now, I'm
well past being tired of doing that.  I suggest it's overdue for
the ACPI team to get this part of their act together.

That is:  either start merging those patches, possibly with updates
to handle broken hardware better; or rewrite them; ... or just say
explicitly the message I've been receiving:  "Linux ACPI will never
support wakeup the way the rest of Linux can and does".  (And the
"why" should be something reasonable.)

