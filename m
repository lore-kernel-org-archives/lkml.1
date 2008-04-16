Return-Path: <linux-kernel-owner+w=401wt.eu-S1762244AbYDPNu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762244AbYDPNu5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 09:50:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751750AbYDPNut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 09:50:49 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:45678 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802AbYDPNus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 09:50:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:sender;
        b=jxi0fSKlGMUwv4UdOEBo5lMiXzJWR4drcZ1Gr3FavYAzBTQE5y6OHrNNWQ5JAmoWa/Tsq6pSHkUTDtpD1YdcLK/L1RJ1Idmh6sSBTtiZqdNXAJ8JAm4myXm//T6noTf07kUsBf2awid3No8SzeUNHnP4XglPKQLkPLVqmn8BoCM=
Message-ID: <48060436.6030707@tuffmail.co.uk>
Date: Wed, 16 Apr 2008 14:50:46 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: linux-kernel@vger.kernel.org
Subject: Re: RFC: Self-snapshotting in Linux
References: <ajbvb-3Ur-21@gated-at.bofh.it> <ajcri-65w-13@gated-at.bofh.it> <da08e304-eb95-4ace-a069-de1a57b86e9f@e39g2000hsf.googlegroups.com> <20080416111237.GA32432@atrey.karlin.mff.cuni.cz>
In-Reply-To: <20080416111237.GA32432@atrey.karlin.mff.cuni.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
>> I guess there is the hardware / drivers issue.  I would like to claim
>> I've found hibernation to be reliable but unfortunately that's not
>> 100% true.
>>     
> So debug it, it is open source after all. Or at least file a bugs.
>   
I definitely want to debug it; I love hibernating.  It's a regression 
and it'll affect my distro kernel once I upgrade to Ubuntu Hardy.

<http://bugzilla.kernel.org/show_bug.cgi?id=10196> "Backtraces during 
hibernate / resume".

I posted the backtraces but nobody could tell me what they were - they 
don't actually say whether they're OOPs or BUGs etc.  They might be 
softlockups - some times I got softlockup warnings, though thats not in 
the log I posted.

The backtraces have been harder to reproduce across different versions / 
configs, but there's definitely an issue where it hangs every time after 
it successfully suspends. It then tends to lock up about a minute after 
resuming.

I'm confused about some details (exactly which versions / configs 
produced which symptoms).  I don't have the machine right now, but I'll 
get back to it some time soon.  I think I managed to get a pair of 
broken and non-broken kernels to work on, and it seems to be a 
regression going from 2.6.22 to 2.6.23.

Any help in clearing up my confusion would be appreciated.  Is it worth 
trying to narrow down exactly where the hang happens between writing the 
hibernation image and shutting down?  If so how?  I suspect that's going 
to be easier than bisecting it.

Alan
