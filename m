Return-Path: <linux-kernel-owner+w=401wt.eu-S1758369AbYC1VYF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758369AbYC1VYF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 17:24:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755398AbYC1VXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 17:23:51 -0400
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:21492 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754562AbYC1VXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 17:23:51 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=AB9upkH8fH6X5XRETlxJ4L7cL6kHBb6fJ6zPwkQqeYQSF27c0PpLmTRmjFxv376+So3vwLxOOSvlhLcsdhItn+umLrbX/t4SRBXiKUWaWxJ47vGR+T1OzXNXhlhA0ApR6iDF+meFR8jW48uGPns0iDL1trFKo8Zc00sYCWnJ8bA=  ;
X-YMail-OSG: 7LFVJOgVM1kbOtXVo..ijecBSbpACEcLVS9xXvnrhhzcN4D08tMrebFsA1NNLn4aPKTLMfFKYA--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: 2.6.25 regression: powertop says 120K wakeups/sec
Date: Fri, 28 Mar 2008 14:09:09 -0700
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org,
       Len Brown <lenb@kernel.org>
References: <20080322202454.9D69DCC0EF@adsl-69-226-248-13.dsl.pltn13.pacbell.net> <200803281244.27012.david-b@pacbell.net> <20080328203014.GA16105@linux-os.sc.intel.com>
In-Reply-To: <20080328203014.GA16105@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803281409.09622.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 28 March 2008, Venki Pallipadi wrote:
> Can you send me the output of
> # grep . /sys/devices/system/cpu/cpu*/cpuidle/*/*
> with upstream kernel.

This is "upstream" to 3085354de635179d70c240e6d942bcbd1d93056c:

/sys/devices/system/cpu/cpu0/cpuidle/state0/desc:CPUIDLE CORE POLL IDLE
/sys/devices/system/cpu/cpu0/cpuidle/state0/latency:0
/sys/devices/system/cpu/cpu0/cpuidle/state0/name:C0
/sys/devices/system/cpu/cpu0/cpuidle/state0/power:4294967295
/sys/devices/system/cpu/cpu0/cpuidle/state0/time:0
/sys/devices/system/cpu/cpu0/cpuidle/state0/usage:0
/sys/devices/system/cpu/cpu0/cpuidle/state1/desc:<null>
/sys/devices/system/cpu/cpu0/cpuidle/state1/latency:0
/sys/devices/system/cpu/cpu0/cpuidle/state1/name:C1
/sys/devices/system/cpu/cpu0/cpuidle/state1/power:0
/sys/devices/system/cpu/cpu0/cpuidle/state1/time:2781727265
/sys/devices/system/cpu/cpu0/cpuidle/state1/usage:927242422

... as I mentioned, powertop says C2 doesn't get used any more,
moreover that only C0 ever gets used.  The "usage" seems to be
saying otherwise.


> Below is a test patch which should effectively revert commit bc71bec91f987
> Can you check with this patch on latest git and see whether things come back
> to normal.

I'll get back to you with results.

 
> Also, it will help if you can send the output of acpidump from this system.

Sent off-list.

- Dave

