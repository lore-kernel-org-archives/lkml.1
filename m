Return-Path: <linux-kernel-owner+w=401wt.eu-S1751816AbXLAIVE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751816AbXLAIVE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 03:21:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750981AbXLAIUs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 03:20:48 -0500
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:32421 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750852AbXLAIUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 03:20:48 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:Received:Date:From:To:Subject:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=GfvNw0rD847bQZ0RHyB0Q0SKcG6CapudIl4YzYpezn0ZMHErnLc+Oy1pwuqz5n1w/qZ3vGwlFfTQReRTRL/TRIuVExV+FR87X6MBJM1UIBg0JD28uA6R0CvcpYNlx6x41hG+5uesslIVPBiDoPhHUm6VrKeksEgwsbDTx64ACE0=  ;
X-YMail-OSG: 0egW_koVM1kLdDUIiLKnIg7akAn6nqHRQvvh7i7wG734rteIXlCHxWGC193oCWoVwf1eDdCgiE7ro.SrLQb64.Sw_.s.VBydnru5elsHqf48Bc937ofrvYCQAAEe
Date: Sat, 01 Dec 2007 00:20:46 -0800
From: David Brownell <david-b@pacbell.net>
To: mingo@elte.hu
Subject: Re: [patch 2.6.24-rc3] rtc-cmos alarm acts as oneshot
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
References: <200711301418.24033.david-b@pacbell.net>
 <20071201074400.GA14709@elte.hu>
In-Reply-To: <20071201074400.GA14709@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20071201082046.554C622A3A6@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Cool. I'm still wondering about:
>
>   http://bugzilla.kernel.org/show_bug.cgi?id=7014
>
> basically, we had universally working /dev/rtc before, now it appears we 
> dont have it anymore. Or were the problems in this bugzilla present with 
> the old code too?

That bug is filed against that legacy /dev/rtc driver, not rtc-cmos.

The submitter hasn't tried the rtc-cmos code, but since the issue
currently appears to be related to using the HPET in "legacy mode"
(what I call "broken mode"), I'd expect similar problems would show
up with the rtc-cmos code too.

- Dave

