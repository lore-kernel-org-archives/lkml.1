Return-Path: <linux-kernel-owner+w=401wt.eu-S1751360AbZHaHem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751360AbZHaHem (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 03:34:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751273AbZHaHel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 03:34:41 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:58887 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbZHaHek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 03:34:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=Vn+j5SnI4wIRozzuU8Ty78AWzCWUkN6EDFM92gqksLv/ewlkbTWahBhOveWhyDvQQb
         nE+Tg66fD8S5lArp+eNPbaSnycJBwg19d/gH3auUGTM38UOFJF45tN7xWyWa9yaDhcJm
         Xtk1CC7ZP/zcmaaqJJfGaWhuTBlFV7ORJyAtY=
Date: Mon, 31 Aug 2009 09:34:29 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, kjwinchester@gmail.com,
       tglx@linutronix.de, borislav.petkov@amd.com,
       linux-tip-commits@vger.kernel.org
Subject: Re: [PATCH 3/3] x86, AMD: Disable wrongly set X86_FEATURE_LAHF_LM
 CPUID bit
Message-ID: <20090831073429.GA26596@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@googlemail.com>,
	"H. Peter Anvin" <hpa@zytor.com>, mingo@redhat.com,
	linux-kernel@vger.kernel.org, kjwinchester@gmail.com,
	tglx@linutronix.de, borislav.petkov@amd.com,
	linux-tip-commits@vger.kernel.org
References: <1251633031-2244-1-git-send-email-petkovbb@gmail.com>
 <1251633031-2244-3-git-send-email-petkovbb@gmail.com>
 <4A9AD17A.6060507@zytor.com>
 <20090830193039.GB22234@liondog.tnic>
 <4A9ADAC3.3020004@zytor.com>
 <20090830202926.GC22234@liondog.tnic>
 <4A9AE5B1.80305@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4A9AE5B1.80305@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 30, 2009 at 01:48:49PM -0700, H. Peter Anvin wrote:
> On 08/30/2009 01:29 PM, Borislav Petkov wrote:
> > 
> > Ok, what do we want actually? We have rdmsr_safe and rdmsrl_safe where
> > the last one engineers the 2 u32s into a u64. My gut feeling would opt
> > for the 2 32bit values instead of one 64bit since they're naturally
> > returned into %eax:%edx. And in the most cases we need only one of the
> > values. However, the MSRs themselves are 64bit... Hmmm...
> > 
> 
> The 2x32 bit interface is the legacy interface.  It turned out to be a
> bad idea, but it's hard to clean up all the users.

Ok, fixed. All other small-ish problems addressed too.

-- 
Regards/Gruss,
    Boris.
