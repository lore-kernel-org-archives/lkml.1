Return-Path: <linux-kernel-owner+w=401wt.eu-S1754715AbZKMVew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715AbZKMVew (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 16:34:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754289AbZKMVeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 16:34:46 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:55728 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774AbZKMVep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 16:34:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=exEhneIWEU7nRDP3HxIzY6ahfa4ZrGKBsK3v6GIZThwlFI1ZbxXd5gPL5mvER7euQG
         IDZ/tkwTg7g1qVMf03jquSl0EirkUmdmQiQMWuDEiW8BL1EiFaZISFKI5UvqMhBAG+Nm
         jLRvzNNdLe+Fjl7UY4dI7cAqOlx9wmzWuKYv0=
Message-ID: <4AFDD0EF.7000809@lwfinger.net>
Date: Fri, 13 Nov 2009 15:34:39 -0600
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

Thanks for that info. I should have said my Turion 64 X2 is different.

Larry
