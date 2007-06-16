Return-Path: <linux-kernel-owner+w=401wt.eu-S1757473AbXFPNiv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757473AbXFPNiv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 09:38:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755267AbXFPNim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 09:38:42 -0400
Received: from s2.ukfsn.org ([217.158.120.143]:50255 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754831AbXFPNil (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 09:38:41 -0400
Message-ID: <4673E7DC.80508@dgreaves.com>
Date: Sat, 16 Jun 2007 14:38:36 +0100
From: David Greaves <david@dgreaves.com>
User-Agent: Mozilla-Thunderbird 2.0.0.0 (X11/20070601)
MIME-Version: 1.0
To: david@lang.hm
Cc: Neil Brown <neilb@suse.de>, Wakko Warner <wakko@animx.eu.org>,
       linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: limits on raid
References: <Pine.LNX.4.64.0706141957020.29630@asgard.lang.hm> <18034.479.256870.600360@notabene.brown> <Pine.LNX.4.64.0706142034400.29630@asgard.lang.hm> <18034.3676.477575.490448@notabene.brown> <20070616020320.GB2002@animx.eu.org> <18035.23867.576212.859440@notabene.brown> <Pine.LNX.4.64.0706160037220.7557@asgard.lang.hm>
In-Reply-To: <Pine.LNX.4.64.0706160037220.7557@asgard.lang.hm>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

david@lang.hm wrote:
> On Sat, 16 Jun 2007, Neil Brown wrote:
> 
> I want to test several configurations, from a 45 disk raid6 to a 45 disk 
> raid0. at 2-3 days per test (or longer, depending on the tests) this 
> becomes a very slow process.
Are you suggesting the code that is written to enhance data integrity is 
optimised (or even touched) to support this kind of test scenario?
Seriously? :)

> also, when a rebuild is slow enough (and has enough of a performance 
> impact) it's not uncommon to want to operate in degraded mode just long 
> enought oget to a maintinance window and then recreate the array and 
> reload from backup.

so would mdadm --remove the rebuilding disk help?

David

