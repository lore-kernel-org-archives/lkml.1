Return-Path: <linux-kernel-owner+w=401wt.eu-S1754963AbZKLXEN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754963AbZKLXEN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 18:04:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755033AbZKLXEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 18:04:06 -0500
Received: from artax.karlin.mff.cuni.cz ([195.113.26.195]:47220 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755049AbZKLXEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 18:04:05 -0500
Date: Thu, 12 Nov 2009 13:16:19 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Ma, Ling" <ling.ma@intel.com>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] [X86] performance improvement for memcpy_64.S by
	fast string.
Message-ID: <20091112121619.GD1394@ucw.cz>
References: <1257500482-16182-1-git-send-email-ling.ma@intel.com> <4AF457E0.4040107@zytor.com> <4AF4784C.5090800@zytor.com> <8FED46E8A9CA574792FC7AACAC38FE7714FCF772C9@PDSMSX501.ccr.corp.intel.com> <4AF7C66C.6000009@zytor.com> <20091109080830.GI453@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091109080830.GI453@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Ling, if you are interested, could you send a user-space test-app to 
> this thread that everyone could just compile and run on various older 
> boxes, to gather a performance profile of hand-coded versus string ops 
> performance?
> 
> ( And i think we can make a judgement based on cache-hot performance
>   alone - if then the strings ops will perform comparatively better in
>   cache-cold scenarios, so the cache-hot numbers would be a conservative
>   estimate. )

Ugh, really? I'd expect cache-cold performance to be not helped at all
(memory bandwidth limit) and you'll get slow down from additional
i-cache misses...
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
