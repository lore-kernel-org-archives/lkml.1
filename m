Return-Path: <linux-kernel-owner+w=401wt.eu-S1752009AbZH3TR7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009AbZH3TR7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 15:17:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751243AbZH3TR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 15:17:58 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:46365 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbZH3TR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 15:17:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=LjvtP6S9OHwgVsGhDCGflwFBK1q19tdGYATNkMwPyvUNTTPaObziGXmbBPGce1IR5Q
         xfZYli4gviwXJK5OIY5GCwHH6nBTkNFxYCfYfhka5e53NpgBdCB4DHrAfmHuBxKjNma0
         nBzCVbcENMzDhbmmE5FOtYr6zqDUR5HRl/7v4=
Date: Sun, 30 Aug 2009 21:17:54 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, mingo@redhat.com,
       linux-kernel@vger.kernel.org, kjwinchester@gmail.com,
       tglx@linutronix.de, borislav.petkov@amd.com,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86, AMD: Disable wrongly set
 X86_FEATURE_LAHF_LM CPUID bit
Message-ID: <20090830191754.GA22234@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@googlemail.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
	mingo@redhat.com, linux-kernel@vger.kernel.org,
	kjwinchester@gmail.com, tglx@linutronix.de, borislav.petkov@amd.com,
	linux-tip-commits@vger.kernel.org
References: <tip-c74cb13b94118ec89e48849806356b67caa5ff86@git.kernel.org>
 <20090816064132.GA16278@elte.hu>
 <20090816214934.GB7765@liondog.tnic>
 <4A8EDC02.8000508@zytor.com>
 <20090822163750.GA31631@liondog.tnic>
 <4A92F93F.8000502@zytor.com>
 <20090825055215.GA22595@liondog.tnic>
 <4A93884E.3000403@zytor.com>
 <20090830114329.GA9038@liondog.tnic>
 <4A9AB1D0.7000403@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4A9AB1D0.7000403@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 30, 2009 at 10:07:28AM -0700, H. Peter Anvin wrote:
> Looks good... there are a few minor tweaks to the assembly (in
> particular, if we're going to do the single file with a macro then the
> macro invocation should be outside the architecture #ifdef; second, I
> realized a better implementation of the 64-bit code after I sent you
> the email) but I can take care of this.

Cool. Could you please move the macro invocations too then, while you're
at it.

> This is for .32, right?

Yep, I'd like to play it safe here so let's have it properly tested
first. I will backport it to .31 and at least .30 later.

Thanks.

-- 
Regards/Gruss,
    Boris.
