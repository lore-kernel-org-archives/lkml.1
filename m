Return-Path: <linux-kernel-owner+w=401wt.eu-S1764982AbXJOXva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764982AbXJOXva (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 19:51:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755202AbXJOXvV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 19:51:21 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:63843 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757424AbXJOXvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 19:51:20 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: Killing a network connection
To: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Stefan Monnier <monnier@iro.umontreal.ca>
Reply-To: 7eggert@gmx.de
Date: Tue, 16 Oct 2007 01:50:55 +0200
References: <9eFcS-It-3@gated-at.bofh.it> <9eGsi-2Sr-35@gated-at.bofh.it>
User-Agent: KNode/0.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8Bit
Message-Id: <E1IhZi3-0001Hd-Ug@be1.lrz>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX19QgcJ6HYzJRtb2OB6zqo6hrYAMO9ayTHGPoZa
 xzkFxc1stxvqs9AKj4kbzYxgwUjz+8cQhKan/SlcmlqHt0EN2c
 /1Gg0LHFHAfb7brp+7Z6g==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> wrote:
> Stefan Monnier <monnier@iro.umontreal.ca> writes:

>> The main use for me is to deal with dangling connections due to taking
>> network interfaces up&down with different IP addresses (typically the wlan0
>> interface where the IP is different because I've modes from an AP to
>> another).  Of course, maybe there's another way to solve this particular
>> problem, in case I'd like to hear about it as well.
> 
> Long ago I did a 2.4 patch that solved exactly this problem. It introduced
> a new ifconfig flag "dynamic" and when a dynamic address went down
> all TCP connections originating from it were killed. It's still available
> in older SUSE releases. I might post a forward port later.

There is a /proc/sys/net/ipv4/ip_dynaddr sysctl in 2.6.21.
-- 
If at first you don't succeed, call it version 1.0 

Friﬂ, Spammer: f.qxmdo@Mzdadi-.7eggert.dyndns.org
 jzdhuDjwc@f.7eggert.dyndns.org czwFbC@cz.7eggert.dyndns.org
