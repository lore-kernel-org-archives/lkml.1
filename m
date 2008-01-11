Return-Path: <linux-kernel-owner+w=401wt.eu-S1760010AbYAKJ2w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760010AbYAKJ2w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 04:28:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755239AbYAKJ2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 04:28:44 -0500
Received: from home.nigel.suspend2.net ([203.171.70.205]:33158 "EHLO
	server1.example.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753902AbYAKJ2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 04:28:43 -0500
Message-ID: <478736C6.3080802@suspend2.net>
Date: Fri, 11 Jan 2008 20:28:38 +1100
From: nigel@suspend2.net
Reply-To: nigel@nigel.suspend2.net
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: David Dillow <dillowda@ornl.gov>, Guillaume Chazarain <guichaz@yahoo.fr>,
       linux-kernel@vger.kernel.org, linux-btrace@vger.kernel.org,
       mingo@redhat.com, tglx@linutronix.de
Subject: Re: CONFIG_NO_HZ breaks blktrace timestamps
References: <1199918912.8388.13.camel@lap75545.ornl.gov> <1199996752.9159.46.camel@lap75545.ornl.gov> <20080110234438.4826f658@inria.fr> <1200020661.5099.3.camel@obelisk.thedillows.org> <20080111090723.GI6258@kernel.dk>
In-Reply-To: <20080111090723.GI6258@kernel.dk>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

Jens Axboe wrote:
> On Thu, Jan 10 2008, David Dillow wrote:
>> On Thu, 2008-01-10 at 23:44 +0100, Guillaume Chazarain wrote:
>>> David Dillow <dillowda@ornl.gov> wrote:
>>>
>>>> At the moment, I'm not sure how to track this farther, or how to fix it
>>>> properly. Any advice would be appreciated.
>>> Just out of curiosity, could you try the appended cumulative patch and
>>> report .clock_warps, .clock_overflows and .clock_underflows as you did.
>> With those patches, CONFIG_NO_HZ works just fine.

Could these patches also help with hibernation issues? I'm trying
x86_64+NO_HZ, and seeing activity delayed during the atomic copy and
afterwards until I manually generate interrupts (by pressing keys).

Regards,

Nigel

