Return-Path: <linux-kernel-owner+w=401wt.eu-S1765685AbZDIMaE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765685AbZDIMaE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 08:30:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759518AbZDIM3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 08:29:50 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:63489 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758111AbZDIM3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 08:29:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=FVpkim0hVIVjeyi1fAq1aPTCaWqbgHPoOmHtQssE+Fu9iGXqoFFsc0j0rHMh3leXxo
         QwMR6S3eUxNnMewjgqXef2UB0g8bXwGYfCmVSvEwrxQLLM7Jzzw8kgSFdw55syucBaxo
         AgD6xyd6eWaurXPH5bC7cNPffs0J01I/N96Nk=
MIME-Version: 1.0
Reply-To: alan-jenkins@tuffmail.co.uk
In-Reply-To: <49DDD83F.507@tuffmail.co.uk>
References: <49DDD83F.507@tuffmail.co.uk>
Date: Thu, 9 Apr 2009 13:29:47 +0100
Message-ID: <9b2b86520904090529u4586906ei878967c2636417be@mail.gmail.com>
Subject: Re: Regression: First hibernation attempt fails
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: linux-pm@lists.linux-foundation.org
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/9/09, Alan Jenkins <alan-jenkins@tuffmail.co.uk> wrote:
> Yet another issue in 2.6.30-rc1 which was not present in 2.6.29 :-).  I
> wonder if it rings any bells?
>
> On my laptop (EEE 4G), the first attempt at hibernation fails.
> Subsequent attempts succeed.
>
> If I use s2disk as normal, I see "snapshotting system", then before it
> gets to write out the image, it aborts and switches back to X.   I can't
> see any error message, even if I check the log with "dmesg".
>
> If I use "echo disk > /sys/power/state", echo reports the error "Cannot
> allocate memory".
>
> This only happens if I've logged in to X first.  In fact, I narrowed it
> down to gnome-power-manager.  If I kill gnome-power-manager beforehand,
> then it doesn't happen.

Hmm... killing g-p-m doesn't seem to affect this any more, perhaps I
spoke too soon.  But not logging into X still avoids it.
