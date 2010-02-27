Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966857Ab0B0MJE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 07:09:04 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:49900 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966434Ab0B0MJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 07:09:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=VmtefNWBPvNqY9AzuRaMcu2WCQbgU5No9QOGzxi9XfMAnOiTpZqa5MFG4E7Y6TyiQf
         EVQGm8Q0nhVqvUafEJFVcYefraOf++sQfHawmJuOIhounOH5N1qVnaHdUrlKa3vMubOf
         N37lUcJpc04ONjY0U6lYMK26WDbImBQMuRY9w=
Date: Sat, 27 Feb 2010 13:06:30 +0100
From: Borislav Petkov <petkovbb@googlemail.com>
To: reg@dwf.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: How to see kernel pr_err error messages.
Message-ID: <20100227120630.GA18061@a1.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@googlemail.com>, reg@dwf.com,
	linux-kernel@vger.kernel.org
References: <201002271011.o1RAB3in007369@deneb.dwf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <201002271011.o1RAB3in007369@deneb.dwf.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: reg@dwf.com
Date: Sat, Feb 27, 2010 at 03:11:03AM -0700

> Im looking at some kernel code, and there are 'pr_err' error messages in
> it that would help me discover my problem.
> 
> However I dont see them printing anywhere.
> 
> What do I have to do to see these error messages?

Take a look at 'ignore_loglevel' and 'loglevel' kernel parameters in
<Documentation/kernel-parameters.txt> depending on what exactly you want
to achieve.

> A search with GOOGLE  and a grep of the code wasnt too useful, but
> it seems possible that I need to set
> 
>     #define CONFIG_DEBUG
> 
> Is that true?  I see a lot of <something>_DEBUGs in the .config file
> but no simple CONFIG_DEBUG that is commented out.

I think this is referring to pr_debug() calls. Those get called when you
add

#define DEBUG

to the file containing them. Otherwise they're optimized away.

-- 
Regards/Gruss,
Boris.
