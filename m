Return-Path: <linux-kernel-owner+w=401wt.eu-S1756088AbYCKFqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088AbYCKFqQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 01:46:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753060AbYCKFp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 01:45:59 -0400
Received: from mail.lang.hm ([64.81.33.126]:58231 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752964AbYCKFp7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 01:45:59 -0400
Date: Mon, 10 Mar 2008 22:48:08 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Daniel Phillips <phillips@phunq.net>
cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
In-Reply-To: <200803102222.15230.phillips@phunq.net>
Message-ID: <alpine.DEB.1.00.0803102247110.22040@asgard.lang.hm>
References: <200803092346.17556.phillips@phunq.net> <20080311050638.GA12498@kroah.com> <200803102222.15230.phillips@phunq.net>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Mar 2008, Daniel Phillips wrote:

> On Monday 10 March 2008 22:06, Greg KH wrote:
>> On Sun, Mar 09, 2008 at 10:46:16PM -0800, Daniel Phillips wrote:
>>> Set ramback to flush mode:
>>>
>>>   echo 1 >/proc/driver/ramback/<devname>
>>
>> /proc is so 1990's.  As your code has nothing to do with processes,
>> please don't add new files in /proc/.  sysfs is there for you to do
>> stuff like this.
>
> Demonstrate some advantage and I will think about it.

use of /proc is discouraged, if you insist on sticking with it in the face 
of opposition you will seriously hurt the chance of your patches being 
accepted.

David Lang
