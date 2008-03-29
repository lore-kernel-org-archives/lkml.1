Return-Path: <linux-kernel-owner+w=401wt.eu-S1759585AbYC2APr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759585AbYC2APr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 20:15:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759463AbYC2APY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 20:15:24 -0400
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:44295 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759454AbYC2APW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 20:15:22 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=21VZlGbJ2zqjoC/Qd4ZsOGOSJZWzTUNznfQz77jDzMJaEl+6ixsIvz3zkHTYMZ21osZQ4qGJeN2I1WzYeuLKffzolw9BOR9kuCoUki65uJsjtAxJPd9Fke4KSJ3RxyvJZRDnl57uVfHv2gFK0eGLW+i3W7FpLqPUJpYMiIfjo7M=  ;
X-YMail-OSG: ljDUVtcVM1lqZ7nu2NU6SLN6_wwNO_O6FsSYlgQsxJQ7Izp8rXB1yX25P1MjCbuFRr7JoNxtBw--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: 2.6.25 regression: powertop says 120K wakeups/sec
Date: Fri, 28 Mar 2008 17:15:19 -0700
User-Agent: KMail/1.9.6
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org,
       "Len Brown" <lenb@kernel.org>
References: <20080322202454.9D69DCC0EF@adsl-69-226-248-13.dsl.pltn13.pacbell.net> <200803281636.04029.david-b@pacbell.net> <924EFEDD5F540B4284297C4DC59F3DEEC83EF5@orsmsx423.amr.corp.intel.com>
In-Reply-To: <924EFEDD5F540B4284297C4DC59F3DEEC83EF5@orsmsx423.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803281715.19973.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 28 March 2008, Pallipadi, Venkatesh wrote:
> 100% C0 is not real reading. The problem behind that is there is no wat
> to measure exact C1 idle time with halt based C1s. So, we always used to
> report 0 time in acpi and that's what is reported by powertop.
> This should be fixed in future, as we now export approx time (even
> though not exact) in cpuidle and powertop is about to start using it.

I just pulled the latest powertop SVN and see it's smarter now.
It says over 90% in C1 (doing normal desktop stuff), with nasty
IRQ rates but that's the fault of silly desktop code.  ;)

- Dave

