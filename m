Return-Path: <linux-kernel-owner+w=401wt.eu-S1755572AbZBOTmF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572AbZBOTmF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 14:42:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752306AbZBOTlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 14:41:52 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:56491 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221AbZBOTlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 14:41:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=M4bOgZk0kQA5QX4TOb5Og4uMbHLxNGVgwxpxYoqOHKDVKuGC3o52isjb2U8MY69w2L
         0vqHRavZcsKFQ36E/RiE5RY5leGIKb6zqkcB5ZsUHR4ANzYafB2q0r6wazPa56cmPvOD
         6XlbPOLh0PPUxetNsvTqLiiOPPJyAa8/BRwrs=
Date: Sun, 15 Feb 2009 20:41:48 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Poking ieee80211_default_rc_algo causes kernel lockups
Message-ID: <20090215194147.GB5790@nowhere>
References: <slrngpgfil.5gc.sitsofe@sitsofe.eeepc.localdomain> <20090215170214.GK5835@nowhere> <883216.75749.qm@web110607.mail.gq1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <883216.75749.qm@web110607.mail.gq1.yahoo.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 15, 2009 at 11:24:41AM -0800, Sitsofe Wheeler wrote:
> > Could you please enable the CONFIG_DETECT_SOFTLOCKUP option in your kernel?
> 
> > It's on Kernel Hacking > Detect Soft Lockups.
> > With some chances you will have a relevant stacktrace of the lockup, in case
> > I couldn't reproduce it.
> 
> I'll try (the kernel I'm currently using is jam packed with with debug options) but I'm unconvinced it will unfreeze enough for anything useful...

No need to actually, I guess we found it...

