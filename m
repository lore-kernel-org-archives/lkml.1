Return-Path: <linux-kernel-owner+w=401wt.eu-S1758142AbYFJXxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758142AbYFJXxb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 19:53:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754199AbYFJXxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 19:53:23 -0400
Received: from mail-dub.bigfish.com ([213.199.154.10]:64063 "EHLO
	mail113-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754136AbYFJXxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 19:53:22 -0400
X-Greylist: delayed 1190 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Jun 2008 19:53:21 EDT
X-BigFish: VPS-36(zz1432R98dR7efV1805M69jzz10d3izzz2fh6bh61h)
X-Spam-TCS-SCL: 0:0
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 160.33.98.75;Service: EHS
Message-ID: <484F0122.6080700@am.sony.com>
Date: Tue, 10 Jun 2008 15:33:06 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] add diffconfig utility
References: <484ED902.9040000@am.sony.com> <1213135624.2534.99.camel@shinybook.infradead.org>
In-Reply-To: <1213135624.2534.99.camel@shinybook.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Jun 2008 22:34:55.0474 (UTC) FILETIME=[34D96520:01C8CB4A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Woodhouse wrote:
> On Tue, 2008-06-10 at 12:41 -0700, Tim Bird wrote:
>> +# Added and removed items are shown with a leading plus or minus,
>> +# respectively.  Changed items show the old and new values on a
>> +# single line.
> 
> It'd be really nice if it could give its output in the same form as
> the .config file itself -- so it'd look something like:
> 
> # CONFIG_FOO is not set
> CONFIG_BAR=y

Would an option for that style of output be OK?

The tool currently produces something similar
to a diff (but with changed lines compressed to
a single line for conciseness).  It should be easy
to produce something that can be used with another
tool to transform one config into another.

It's unclear what to do with variables that are
supposed to be removed from the config (as opposed
to be set to "CONFIG_FOO is not set"  Does merge.pl
handle this, or is this left to something like
'make oldconfig'?
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

