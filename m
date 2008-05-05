Return-Path: <linux-kernel-owner+w=401wt.eu-S1755953AbYEERnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755953AbYEERnZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 13:43:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752028AbYEERnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 13:43:17 -0400
Received: from 2605ds1-ynoe.1.fullrate.dk ([90.184.12.24]:46272 "EHLO
	shrek.krogh.cc" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751825AbYEERnQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 13:43:16 -0400
Message-ID: <481F4728.9050100@krogh.cc>
Date: Mon, 05 May 2008 19:43:04 +0200
From: Jesper Krogh <jesper@krogh.cc>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Ray Lee <ray-lk@madrabbit.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: Many open/close on same files yeilds "No such file or directory".
References: <4819E316.7000607@krogh.cc>	 <20080501223938.921f7cd2.akpm@linux-foundation.org>	 <481ACEC4.2040205@krogh.cc> <481B3115.30705@krogh.cc> <2c0942db0805020847q2fdc0480m3eb892bf2bd0b3a@mail.gmail.com> <481B70F9.6000201@krogh.cc>
In-Reply-To: <481B70F9.6000201@krogh.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesper Krogh wrote:
> Ray Lee wrote:
>> BTW, I may have missed this earlier, but does it happen *anywhere* on
>> the troublesome filesystem (ie, in a newly created subdirectory)?
> 
> Yes. It is reproducible on a newly created subdirectory on the
> filesystem.

Now I've created a new filesystem. (resized the original LVM-volume to 
half and created a new ext3 one next to it). The problem persists on 
this new filesystem.

Just guessing, can there be something timing related in clearing the 
FS-cache for the filesystem?

Any other suggestions/pointers.



Jesper
-- 
Jesper
