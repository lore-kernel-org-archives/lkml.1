Return-Path: <linux-kernel-owner+w=401wt.eu-S1757020AbZKNDkw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757020AbZKNDkw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 22:40:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755728AbZKNDkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 22:40:51 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:59899 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755465AbZKNDku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 22:40:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=lR+K2LxwgQa3uYJqC4EK8s6UwL1ymSPV9lPPmZ6mFT+zuxfx9Rh8CjxzllCu9gk+Gg
         ByQjfnDXC2HHlpr5Avb36TjNu09F/FgHZlqG8RH3pd2+qIOtdhmQcx1go6hlZnbg4+An
         7IAMXw+9CEZNZ4qCa92GkCDgcidiDqLXQMsEc=
Message-ID: <4AFE26C5.5080402@lwfinger.net>
Date: Fri, 13 Nov 2009 21:40:53 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Michael Buesch <mb@bu3sch.de>, bcm43xx-dev@lists.berlios.de,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 64-bit DMA problems with BCM4312 using b43
References: <4AFD958E.1000303@lwfinger.net> <20091113201112.GA5540@srcf.ucam.org> <200911132144.24110.mb@bu3sch.de> <4AFDCA0E.4080007@lwfinger.net> <20091113211306.GA6600@srcf.ucam.org>
In-Reply-To: <20091113211306.GA6600@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2009 03:13 PM, Matthew Garrett wrote:
> On Fri, Nov 13, 2009 at 03:05:18PM -0600, Larry Finger wrote:
> 
>> I'm in the process of creating a patch to set the latency to 200 usec. The
>> default is 2000. On my fast prosessors, it should not be anything nearly that
>> slow. If we determine this to be the problem, then we can try tuning.
> 
> The latency is the amount of time it takes to get out of deep C states 
> and into C0. That's a function of the processor design rather than the 
> frequency.

Thanks for your suggestion. The value of 200 fixed one of the two machines and
greatly improved the other. He is currently testing with a value of 150, and
will try 100 if that still fails.

Larry


