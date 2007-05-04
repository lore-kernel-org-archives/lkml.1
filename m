Return-Path: <linux-kernel-owner+w=401wt.eu-S1161395AbXEDXLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161395AbXEDXLT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 19:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161486AbXEDXLT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 19:11:19 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:24335 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161395AbXEDXLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 19:11:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=UR+WvTg5ac5+jyDOUUDpJldm88NtfOwb5R/fYVSoq0cw4BzZ4MXsBNfR9lD8EoENyKtOhXR3iEnk/+oF2iwdyREVNvuuJKi6jCrqKj7D2HRg+A0qq1TANRbOdnp3jCW/s7RpOl8Of1XwRYMbmn2/NPsV4ARrm+zQwpJClx4CFU4=
Message-ID: <2c0942db0705041611u2d82fbb7m4719c1bcf8bcdbf7@mail.gmail.com>
Date: Fri, 4 May 2007 16:11:17 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFT][PATCH] swsusp: Change code ordering related to ACPI
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Marcus Better" <marcus@better.se>, "Pavel Machek" <pavel@ucw.cz>,
       "Tobias Diedrich" <ranma+kernel@tdiedrich.de>,
       "pm list" <linux-pm@lists.linux-foundation.org>
In-Reply-To: <200705041143.02451.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200705041143.02451.rjw@sisk.pl>
X-Google-Sender-Auth: b1e6b7f337e18ffa
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/4/07, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> The change of the hibernation/suspend code ordering made before 2.6.21 has
> caused some systems to have problems related to ACPI.  In particular, the
> 'platform' hibernation mode doesn't work any more on some systems.

It seems that somewhere between 2.6.21-rc4 and 2.6.21 final my laptop
stopped being able to come out of suspend to RAM. Before I start
bisecting (again, sigh), is this ringing any bells for anyone? In
particular your, patch (snipped) that deals with hibernation, would it
also affect suspend to RAM?

Ray
