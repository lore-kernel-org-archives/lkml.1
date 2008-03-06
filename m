Return-Path: <linux-kernel-owner+w=401wt.eu-S1765672AbYCFTp7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765672AbYCFTp7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 14:45:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756602AbYCFTpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 14:45:05 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:10490 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756228AbYCFTpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 14:45:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:sender;
        b=fri0AK+73hEToBkCWwvOhn3H7vETVrTZwukHyyM+nhRGKJMTC4i7FSZ9BiEkBQIrvXVbH7HH8/oMYJGfZR22OZoN3/mbt3xoKEkJ8S7lf+DM920Y/m03XMe7/FFYeir/GHWt3YXI5XzNIECA/B/xINP2tFk7zkoDvVU513sv40o=
Message-ID: <47D049B8.6000404@gnu.org>
Date: Thu, 06 Mar 2008 20:44:56 +0100
From: Paolo Bonzini <bonzini@gnu.org>
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
MIME-Version: 1.0
To: Andrew Pinski <pinskia@gmail.com>
CC: gcc@gcc.gnu.org, linux-kernel@vger.kernel.org
Subject: Re: RELEASE BLOCKER: Linux doesn't follow x86/x86-64 ABI wrt direction
 flag
References: <2F47E21A-9055-4EC3-99CF-B666BBC045C3@apple.com> 	 <578FCA7D-D7A6-44F6-9310-4A97C13CDCBE@apple.com> 	 <47CF44E7.3020106@zytor.com> <20080306135139.GA5236@dspnet.fr.eu.org> 	 <47CFF9A3.30309@gnu.org> <20080306141221.GC5236@dspnet.fr.eu.org> 	 <20080306175841.GI17267@synopsys.com> 	 <20080306181029.GA42904@dspnet.fr.eu.org> <47D03440.6090503@gnu.org> 	 <20080306183146.GL27983@randombit.net> <de8d50360803061035w31622950lfc0cdcfb94b8ea34@mail.gmail.com>
In-Reply-To: <de8d50360803061035w31622950lfc0cdcfb94b8ea34@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>  If the malicious process can send a signal to another process, it
>>  could also ptrace() it. Which is more useful, if you wanted to be
>>  malicious?
> 
> And more to the point, it can happen before GCC 4.3.0.

Yes, and that's why the kernel should just fix it, and the fix should be 
backported and treated like any other security fix.

Paolo
