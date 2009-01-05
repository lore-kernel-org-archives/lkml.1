Return-Path: <linux-kernel-owner+w=401wt.eu-S1755218AbZAEOks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218AbZAEOks (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 09:40:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754340AbZAEOkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 09:40:40 -0500
Received: from ti-out-0910.google.com ([209.85.142.186]:63398 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754111AbZAEOkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 09:40:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=RDhy9qW1JK8chkaqoD+Xu9id+sIR6uk3+0r4tzsvoaPt/r2Mgv+Otp+zEeuC8n1zkl
         pY08iIpP784JhuoUEb8Ok6WrH9UCxjZrWq8Dg7LThueM9PUDSXj3flEXfXkcr/Scc0Zl
         CucBdomtmI9EuV7FSRdpH5VRGtxMiGqc0WnuI=
Message-ID: <df9815e70901050640k6f0527c5v4eae02ccb2295bc3@mail.gmail.com>
Date: Mon, 5 Jan 2009 22:40:36 +0800
From: "Jike Song" <albcamus@gmail.com>
To: "Matthew Garrett" <mjg59@srcf.ucam.org>
Subject: Re: [BUG] 2.6.28 hates my RTC clock - with PM_TRACE set
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090105143338.GA32337@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <df9815e70901050619v6c60e8d4w6868759bb3c36bdb@mail.gmail.com>
	 <20090105143338.GA32337@srcf.ucam.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 5, 2009 at 10:33 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Mon, Jan 05, 2009 at 10:19:22PM +0800, Jike Song wrote:
>
>> As usually, it suspended to RAM successfully.  But after I press the
>> power button, it won't come back, giving me nothing but a black
>> screen.  So I hold the power button done for about 5 seconds, then the
>> computer halted(it's only a hardware feature of the southbridge,
>> right? ;-), silently, without any output on the always-black screen.
>>
>> So the PM_TRACE code was broken, right?
>
> Why do you say that?
>
>> After rebooting the computer, I found I was in the year 1988!  And I
>> do the suspend-hold_power_button-reboot once again, now it is 2040
>> years A.D.
>
> PM_TRACE uses the clock registers to store information about which
> device the kernel was attempting to resume when it hung. It's expected
> that your clock will be wrong afterwards.
>
Thanks for you information! I took it for granted that the RTC clock
will be restored after resume/reboot.

So it's only an ordinary S2R bug with a black screen?  I can't see
anything with PM_TRACE.

> --
> Matthew Garrett | mjg59@srcf.ucam.org
>

-- 
Thanks,
Jike
