Return-Path: <linux-kernel-owner+w=401wt.eu-S1762282AbZDCBYz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762282AbZDCBYz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 21:24:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754146AbZDCBYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 21:24:47 -0400
Received: from mail.lang.hm ([64.81.33.126]:53930 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019AbZDCBYq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 21:24:46 -0400
Date: Thu, 2 Apr 2009 18:24:28 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Matthew Garrett <mjg59@srcf.ucam.org>
cc: Theodore Tso <tytso@mit.edu>, Sitsofe Wheeler <sitsofe@yahoo.com>,
       "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>,
       Alberto Gonzalez <info@gnebu.es>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Ext4 and the "30 second window of death"
In-Reply-To: <20090403011953.GA10777@srcf.ucam.org>
Message-ID: <alpine.DEB.1.10.0904021821120.28893@asgard.lang.hm>
References: <20090401151219.GA12285@srcf.ucam.org> <20090401173521.GA15423@mit.edu> <20090401174336.GA14726@srcf.ucam.org> <alpine.DEB.1.10.0904021116500.28893@asgard.lang.hm> <20090402182925.GA4502@srcf.ucam.org> <alpine.DEB.1.10.0904021134560.28893@asgard.lang.hm>
 <20090402234617.GB9538@srcf.ucam.org> <alpine.DEB.1.10.0904021753410.28893@asgard.lang.hm> <20090403010600.GA10545@srcf.ucam.org> <alpine.DEB.1.10.0904021810180.28893@asgard.lang.hm> <20090403011953.GA10777@srcf.ucam.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Apr 2009, Matthew Garrett wrote:

> On Thu, Apr 02, 2009 at 06:16:20PM -0700, david@lang.hm wrote:
>> On Fri, 3 Apr 2009, Matthew Garrett wrote:
>>
>>> On Thu, Apr 02, 2009 at 05:55:11PM -0700, david@lang.hm wrote:
>>>> On Fri, 3 Apr 2009, Matthew Garrett wrote:
>>>>> Then they shouldn't use a mail client that fsync()s.
>>>>
>>>> so they need to use one mail client when they want to have good battery
>>>> life and a different one when they are plugged in to power?
>>>
>>> They need to make a decision about whether they care about their mailbox
>>> being precisely in sync with their server or not, and either use a
>>> client that adapts appropriately or choose a client that behaves
>>> appropriately. It's certainly not the kernel's business.
>>
>> the kernel is not deciding this, the kernel would be implementing the
>> user's choice
>
> No it wouldn't. The kernel would be implementing an adminstrator's
> choice about whether fsync() is important or not. That's something that
> would affect the mail client, but it's hardly a decision based on the
> mail client. Sucks to be that user if they do anything involving mysql.

in the case of laptops, in 99+% of the cases the user and the 
administrator are the same person. in the other cases that's something the 
user should take up with the administrator, because the administrator can 
do a lot of things to the system that will affect the safety of their data 
(including loading a kernel that turns fsync into a noop, but more likely 
involving enabling or disabling write caches on disks)

>>> If you can demonstrate a real world use case where the hard drive
>>> (typically well under a watt of power consumption on modern systems)
>>> spindown policy will be affected sufficiently pathologically by a mail
>>> client that you lose an hour of battery life, then I'd rethink this. But
>>> mostly I'd conclude that this was an example of an inappropriate
>>> spindown policy.
>>
>> remember that the mail client was an example.
>>
>> you want another example, think of anything that uses sqlite (like the
>> firefox history stuff, although that was weakened drasticly due to the
>> ext3 problems).
>
> Benchmarks please.

if spinning down a drive saves so little power that it wouldn't make a 
significant difference to battery lift to leave it on, why does anyone 
bother to spin the drive down?

David Lang
