Return-Path: <linux-kernel-owner+w=401wt.eu-S935102AbYCTAMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935102AbYCTAMh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 20:12:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935148AbYCSX0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 19:26:19 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:22810 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760517AbYCSX0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 19:26:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=FAtbl7XwYrnWYWC69/yTYlMmWq1Sq/4jUJdHHMmM/IMehCUBxI2nFTo8+z3tlpSp9rnl3BfC21lUgtt2VAXf2KRbm2CJCE9xHzQOKFKzPYKKYNqVZZRsu9gwJoSp9sRWqZK8DiI7SfI6aAQtVUXX6PzkpHhhw+HF7RgpjToT2xM=
Message-ID: <47E1A112.4060208@gmail.com>
Date: Thu, 20 Mar 2008 00:26:10 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: marcel@holtmann.org, maxk@qualcomm.com,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: bluetooth still corrupts memory in 2.6.25-rc6
References: <20080319082115.GA14543@elf.ucw.cz> <47E19BA1.8010905@gmail.com> <20080319230624.GJ1811@elf.ucw.cz>
In-Reply-To: <20080319230624.GJ1811@elf.ucw.cz>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed the bluez-devel@.

On 03/20/2008 12:06 AM, Pavel Machek wrote:
> On Thu 2008-03-20 00:02:57, Jiri Slaby wrote:
>> On 03/19/2008 09:21 AM, Pavel Machek wrote:
>>> ...just leave ppp-over-cellphone-over-bluetooth running, and do
>>> s2ram...
>>>
>>> Linux version 2.6.25-rc6 (pavel@amd) (gcc version 4.1.3 20071209 (prerelease) (Debian 4.1.2-18)) #186 SMP Wed Mar 19 00:46:05 CET 2008
>>> BIOS-provided physical RAM map:
>> Pavel, does the "still" from $SUBJ mean, that 2.6.24 is affected too (if 
>> this is the same what I hit)?
> 
> Hey, I did not do careful analysis. I believe it is the same problem
> that affects 2.6.24, too, yes. But I actually believe it is much older
> than that...

If yes, then I got the crash by using hidp over l2cap with non-hid device 
(session->input). I'm not sure if it was connected at all and even if hidd was 
running (I tested moving with mouse by cellphone with switching on and off the 
daemon, since it needed some little changes).

If you, hci fellows, are interested I might send more detailed description of 
the crash tomorrow.
