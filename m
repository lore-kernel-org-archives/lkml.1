Return-Path: <linux-kernel-owner+w=401wt.eu-S1760830AbYEQXQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760830AbYEQXQc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 19:16:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751712AbYEQXQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 19:16:25 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:53191 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbYEQXQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 19:16:24 -0400
Message-ID: <482F67C1.2010809@keyaccess.nl>
Date: Sun, 18 May 2008 01:18:25 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>
CC: Adrian Bunk <bunk@kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Tracking and crediting bug reporters
References: <20080513102849.GB25196@cs181133002.pp.htv.fi> <18918.1210955743@vena.lwn.net> <20080517225325.GD8140@cs181133002.pp.htv.fi>
In-Reply-To: <20080517225325.GD8140@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18-05-08 00:53, Adrian Bunk wrote:

> On Fri, May 16, 2008 at 10:35:43AM -0600, Jonathan Corbet wrote:
>> [Operating in delayed response mode, sorry...]
>>
>> Adrian Bunk <bunk@kernel.org> wrote:
>>
>>> In which format do you want data for commits already in 2.6.26?
>> I hadn't thought about trying to backfill data for existing commits;
>> that sounds like a fair amount of work for coverage which could still be
>> somewhat spotty.  If you have the data at hand, though, then a simple
>> file of the form
>>
>> 	commit-id  full-name <email>
> 
> How to indicate whether it's a Reported-by or a Bisected-by?

Literal Bisected-by might not make for a very good tag. Bisection is a 
way to pin down a bug; just one of them. So say person A reports and 
person B says "Hey, I know what that is. Try reverting foo." B then 
doesn't fit the tag while the only difference is that B was clever 
enough to not need a bisection. So if this is about giving credit; 
Tracked-down-by maybe? Something else?

Rene.
