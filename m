Return-Path: <linux-kernel-owner+w=401wt.eu-S1758101AbZDCBRi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758101AbZDCBRi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 21:17:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755581AbZDCBR3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 21:17:29 -0400
Received: from mail.lang.hm ([64.81.33.126]:33577 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752148AbZDCBR3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 21:17:29 -0400
Date: Thu, 2 Apr 2009 18:17:12 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Matthew Garrett <mjg59@srcf.ucam.org>
cc: Nick Piggin <nickpiggin@yahoo.com.au>, Theodore Tso <tytso@mit.edu>,
       Sitsofe Wheeler <sitsofe@yahoo.com>,
       "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>,
       Alberto Gonzalez <info@gnebu.es>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Ext4 and the "30 second window of death"
In-Reply-To: <20090403010901.GB10545@srcf.ucam.org>
Message-ID: <alpine.DEB.1.10.0904021816420.28893@asgard.lang.hm>
References: <200903291224.21380.info@gnebu.es> <200904030535.00335.nickpiggin@yahoo.com.au> <20090402183834.GB4773@srcf.ucam.org> <200904030556.41270.nickpiggin@yahoo.com.au> <20090402234751.GC9538@srcf.ucam.org> <alpine.DEB.1.10.0904021755250.28893@asgard.lang.hm>
 <20090403010901.GB10545@srcf.ucam.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Apr 2009, Matthew Garrett wrote:

> On Thu, Apr 02, 2009 at 05:59:53PM -0700, david@lang.hm wrote:
>
>> is laptop mode
>>
>> A. "write everything now, don't delay writes" in the hope that the drive
>> will be idle enough later to spin down
>
> laptop-mode doesn't delay writes. Ever.
>
>> or
>>
>> B. "delay all writes until later, then when the drive wakes up do all
>> pending writes at that time" so that the drive can go to sleep in the
>> meantime?
>
> Yes.

you just contridicted yourself in these two statements.

David Lang

>> I've heard things in these threads that would indicate both behaviors.
>
> The code's pretty trivial. The only real functional differences
> laptop-mode brings are to write out all dirty pages (rather than just
> writing down to the watermark) and to call sys_sync() a few seconds
> after the last thing that hit disk rather than being satisfied from
> cache. It's entirely a mechanism to opportunistically take advantage of
> the disk being spun up.
>
>
