Return-Path: <linux-kernel-owner+w=401wt.eu-S1758941AbYCCP6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758941AbYCCP6s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 10:58:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755528AbYCCP6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 10:58:39 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:23146 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754479AbYCCP6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 10:58:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=sJXbEgO5KnAXKvyA40UlVePva+jyf9pJhD2v+OVKW06CJ722lMevzbUiIV/vqyaP888FPSKmZPY+Ryh5wrW7gT1l+rUlUQXg5P8y4l9zqs4cRlsnRlYTwHid8IRB1wdyDv8LD0ViDgkgwBXkp74OGPLiUsg++daTxCnPsHFvPPw=
Subject: Re: [patch] x86: phase out forced inlining
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Adrian Bunk <bunk@kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Alexey Starikovskiy <aystarik@gmail.com>, lenb@kernel.org,
       astarikovskiy@suse.de, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20080303070117.0325e77a@laptopd505.fenrus.org>
References: <20080301161902.GN25835@cs181133002.pp.htv.fi>
	 <47C99FE1.8080206@gmail.com> <20080301183550.GC25835@cs181133002.pp.htv.fi>
	 <20080303085720.GD15943@elte.hu>
	 <20080303091314.GC4457@cs181133002.pp.htv.fi>
	 <20080303091714.GA18250@elte.hu>
	 <20080303093103.GA23651@uranus.ravnborg.org>
	 <20080303103933.GC21190@elte.hu>
	 <20080303113451.GF4457@cs181133002.pp.htv.fi>
	 <20080303114533.GA4183@elte.hu> <20080303121335.GA15381@elte.hu>
	 <20080303070117.0325e77a@laptopd505.fenrus.org>
Content-Type: text/plain
Date: Mon, 03 Mar 2008 07:58:39 -0800
Message-Id: <1204559919.3266.12.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> eh.. we ALREADY HAD THIS.
> someone seems to have removed this wronly; not forcing inline should have been
> the default after the removal (in 2.6.25-rc)!
> 
> So lets fix it that way, rather than putting the config option back under a different name.

The removal was my patch.  I did notice that the config option had no
effect, I figured that was why it was on the removal schedule, as
it had been made the default.

My bad,

Harvey

