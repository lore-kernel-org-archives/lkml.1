Return-Path: <linux-kernel-owner+w=401wt.eu-S935288AbYEBPWK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935288AbYEBPWK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 11:22:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761099AbYEBPVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 11:21:54 -0400
Received: from 2605ds1-ynoe.1.fullrate.dk ([90.184.12.24]:36358 "EHLO
	shrek.krogh.cc" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759860AbYEBPVx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 11:21:53 -0400
Message-ID: <481B317A.9030409@krogh.cc>
Date: Fri, 02 May 2008 17:21:30 +0200
From: Jesper Krogh <jesper@krogh.cc>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: Many open/close on same files yeilds "No such file or directory".
References: <4819E316.7000607@krogh.cc> <20080501223938.921f7cd2.akpm@linux-foundation.org> <481ACEC4.2040205@krogh.cc>
In-Reply-To: <481ACEC4.2040205@krogh.cc>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesper Krogh wrote:
> Andrew Morton wrote:
>>> I cannot reproduce it on other disks attached to the same server or on
>>> other servers attached to similar disksystems.
>> 
>> I guess it would be interesting to remount that filesystem with `noatime'
>> to eliminate the last bit of I/O and block-=realted code.
> 
> It is allready mounted noatime:
> /dev/mapper/fx1200_vg-fx1200_lv on /z/fx1200 type ext3 (rw,noatime)

Watching vmstat 1 while running the program confirms that there are 
absolutely no block i/o. Everything happens purely in the cache of the OS.

Jesper
-- 
Jesper
