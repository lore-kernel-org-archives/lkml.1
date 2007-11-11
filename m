Return-Path: <linux-kernel-owner+w=401wt.eu-S1754772AbXKKElB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772AbXKKElB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 23:41:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751356AbXKKEkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 23:40:52 -0500
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:53386
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932AbXKKEkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 23:40:51 -0500
Date: Sat, 10 Nov 2007 20:50:34 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: John Johansen <jjohansen@suse.de>
cc: "Dr. David Alan Gilbert" <linux@treblig.org>,
       Crispin Cowan <crispin@crispincowan.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       LSM ML <linux-security-module@vger.kernel.org>,
       apparmor-dev <apparmor-dev@forge.novell.com>
Subject: Re: AppArmor Security Goal
In-Reply-To: <20071111041739.GE19216@suse.de>
Message-ID: <Pine.LNX.4.64.0711102048370.4780@asgard.lang.hm>
References: <473380AD.5070801@crispincowan.com> <20071110220455.GB24195@gallifrey>
 <47362C7C.2050202@crispincowan.com> <20071110222414.GC24195@gallifrey>
 <47363381.4030103@crispincowan.com> <20071110232545.GD24195@gallifrey>
 <Pine.LNX.4.64.0711101546400.4780@asgard.lang.hm> <20071111041739.GE19216@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Nov 2007, John Johansen wrote:

> On Sat, Nov 10, 2007 at 03:52:31PM -0800, david@lang.hm wrote:
>> On Sat, 10 Nov 2007, Dr. David Alan Gilbert wrote:
>
>>> Allowing a user to tweak (under constraints) their settings might allow
>>> them to do something like create two mozilla profiles which are isolated
>>> from each other, so that the profile they use for general web surfing
>>> is isolated from the one they use for online banking.
>>
>> the model of being able to add restrictions would still handle this. make
>> two shell scripts (one to start each browser profile) and set the AA policy
>> for these scripts to only have access to the appropriate directories.
>>
> yes you could do this, though I tend to want it just so I can control
> which of my files firefox should be able to touch, without messing
> up system policy.

right, I was showing how you could easily create two different firefox 
browsers being able to access different things, and how it could be done 
with user-based policies that tighten restrictions only (which are being 
considered)

David Lang
