Return-Path: <linux-kernel-owner+w=401wt.eu-S1757996AbYC1XgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757996AbYC1XgT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 19:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756351AbYC1XgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 19:36:08 -0400
Received: from smtp113.sbc.mail.mud.yahoo.com ([68.142.198.212]:44413 "HELO
	smtp113.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756361AbYC1XgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 19:36:07 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=NIH3gYupUtgqj3Y8yCoPOWBPNy2mGBuWVYLL6YfjgLSdj41ww6DA14JnLkHzWIYDMOHgOZGwKVC5qjxV48lwWMxSwDJZsiGpR7MoJwJqxQJ3xrlS+9R4YcPq+ElqlePPHJI1t1wafdhgo1vZFLvxEq5N7S10GDIbEijiN2GfuBo=  ;
X-YMail-OSG: Q0ObWTQVM1nEPI4TtouprGy7ZHzzMFIzsR30KborghFVnc1mbKMR9clkpusD.E4zNrwDYwlrYw--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: 2.6.25 regression: powertop says 120K wakeups/sec
Date: Fri, 28 Mar 2008 16:36:03 -0700
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org,
       Len Brown <lenb@kernel.org>
References: <20080322202454.9D69DCC0EF@adsl-69-226-248-13.dsl.pltn13.pacbell.net> <200803281509.23107.david-b@pacbell.net> <20080328225604.GA7136@linux-os.sc.intel.com>
In-Reply-To: <20080328225604.GA7136@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803281636.04029.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 28 March 2008, Venki Pallipadi wrote:

> I think I figured out the bug...
> 
> Can you try the below patch and confirm that it works (over upstream - ignore
> the earlier revert patch I sent to you).

That seems to do the job ... thanks!  One more regression
fixed, it feels like RC7 is almost done. :)

It still says odd things about C0 vs C1 though:  powertop
says 100% of the time is in C0, but this patch would seem
to be irrelevant if that were true.

- Dave

