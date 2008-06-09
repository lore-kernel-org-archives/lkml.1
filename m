Return-Path: <linux-kernel-owner+w=401wt.eu-S1760219AbYFIOn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760219AbYFIOn3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 10:43:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752709AbYFIOnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 10:43:21 -0400
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:49697 "EHLO
	e28esmtp07.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759145AbYFIOnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 10:43:20 -0400
Message-ID: <484D416F.6050504@linux.vnet.ibm.com>
Date: Mon, 09 Jun 2008 20:12:55 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Scott Wiersdorf <scott@bluehost.com>
CC: Andi Kleen <andi@firstfloor.org>, Balbir Singh <balbir@in.ibm.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       matt@bluehost.com
Subject: Re: [PATCH 2.6.25-4] getdelays.c: signal handling for log rotation
References: <20080605194334.GA56830@perlcode.org> <87d4muu0k2.fsf@basil.nowhere.org> <20080606204704.GA4330@perlcode.org> <4849E09D.6090804@firstfloor.org> <1213021229.4645.67.camel@tub.office.bluehost.com>
In-Reply-To: <1213021229.4645.67.camel@tub.office.bluehost.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Scott Wiersdorf wrote:
> On Sat, 2008-06-07 at 03:13 +0200, Andi Kleen wrote:
>> Scott Wiersdorf wrote: 
>>> I still think a single handler is elegant enough though, and works
>>> better with many log rotation systems that want to send a single
>>> signal to a pid (it's what we need where I'm working now, hence the
>>> patch).
>> Well in general it would be cool if there was nicer free userland for
>> the obscure but useful delay accounting. The code in Documentation
>> is really not much more than a example. Do you have something downloadable?
> 
> I don't. I'm really not much of a C programmer; I'm just hacking on this
> file for our company because we have a use for it. I'm all for it going
> into userland, but don't have the time to be responsible for that.

Andi,

I've come across http://people.suug.ch/~tgr/taskstats/. It seems like a good
implementation. The code in Documentation/accounting is to show a prototype of
the implementation and to keep it updated as we add new features.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
