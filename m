Return-Path: <linux-kernel-owner+w=401wt.eu-S1755361AbZHJOiG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361AbZHJOiG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 10:38:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755204AbZHJOiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 10:38:05 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:51692 "EHLO
	mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050AbZHJOiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 10:38:04 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19072.12488.784321.411653@stoffel.org>
Date: Mon, 10 Aug 2009 10:38:00 -0400
From: "John Stoffel" <john@stoffel.org>
To: Martin Rogge <marogge@onlinehome.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.30.1-4 kernels freezes dual pentium-3 system
In-Reply-To: <200908072229.37485.marogge@onlinehome.de>
References: <200908031825.28045.marogge@onlinehome.de>
	<200908072229.37485.marogge@onlinehome.de>
X-Mailer: VM 8.0.9 under Emacs 22.3.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Martin" == Martin Rogge <marogge@onlinehome.de> writes:

Martin> On Monday 03 August 2009 18:25:27 Martin Rogge wrote:
>> Osipov Stanislav wrote:
>> > I  have  a  dual  Pentium-3 system. It based on Asus CUR-DLS mainboard
>> > with  2  Pentium-3EB  1000MHz (133 MHz FSB) installed.
>> >
>> > [...]
>> >
>> > But  under 2.6.30.x kernels box freezes without any alerts. TTL before
>> > freezing  is  about 5-30 mins.
>> >
>> > [...]
>> >
>> > Thanks in advance,
>> >
>> > Osipov Stanislav
>> > Linux System Administrator.
>> 
>> I also observe system lockups after upgrading to 2.6.30.[34]. The mainboard
>> is an MSI-9105 with dual P-3 1400Mhz. TTL is a number of hours (which is
>> going to make bisecting hard). Since all lockups have occured with a
>> tainted kernel (nvidia) I am currently running a test with an untainted
>> kernel. Should a lockup re-occur I will post details.
>> 
>> Martin

Martin> OK, I have observed the lockup now on a vanilla 2.6.30.4
Martin> kernel, unpatched & untainted. So it is now official: 2.6.30
Martin> can lock up on dual-P3s.:-(

I'm not surprised.  I've been running 2.6.31-rc5 on my Dual PIII and
it's locked up three times now.  I expect it to lockup before I get
home today too.  

I guess I really need to start the long term bisection parade and see
where the changes between 2.6.29 and 2.6.30 really are which causes
this problem.

John
