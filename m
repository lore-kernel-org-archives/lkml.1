Return-Path: <linux-kernel-owner+w=401wt.eu-S1762282AbYHETT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762282AbYHETT7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 15:19:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756644AbYHETTv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 15:19:51 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:43798 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756337AbYHETTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 15:19:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ar1lKbZAgfHllAz7YJ62IYNsm5BkDUz52IppG7IOHn9XmcU9WeEkOPT5nEMvFUnCqF
         OYUvYiDkEPMSFCpzrNyEY2W+GgqHMsp1SpVw3VPnBmemq4Dn3LWniqNFW9KTIrF2bvv5
         G1LtaP5AQSXPwDgkQQqaZWC7P5GlgWgLvd+zg=
Message-ID: <86802c440808051219o58a219a9j8022fc50bd6e1eaa@mail.gmail.com>
Date: Tue, 5 Aug 2008 12:19:48 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "David Witbrodt" <dawitbro@sbcglobal.net>
Subject: Re: HPET regression in 2.6.26 versus 2.6.25
Cc: linux-kernel@vger.kernel.org, "Peter Zijlstra" <peterz@infradead.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <876206.46405.qm@web82102.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <876206.46405.qm@web82102.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 5, 2008 at 7:14 AM, David Witbrodt <dawitbro@sbcglobal.net> wrote:
>
>
>> Since you have that git tree, could you try to see if the latest -git
>> still has this problem?
>
>  I had forgotten to do that at the time I posted.
>
>  Last night, after the post, I _did_ try building "master".  The commit
> date was from Aug. 1 -- I am at work right now, so I can't provide exact
> info until I get home in about 6 hours.  I checked 'Makefile', and the
> version there was 2.6.27-rc1, IIRC.
>  It built fine, but same freeze was seen.
>
>  A reversion of the commit I mentioned _will_ solve the problem, but
> looking at the code I saw that it was an attempt to provide better
> functionality.  I'm willing to help test modifications to make the new
> code work!

please boot with "debug apic=verbose initcall_debut" to check exactly
where it hangs...

YH
