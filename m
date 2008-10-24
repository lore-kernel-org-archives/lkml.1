Return-Path: <linux-kernel-owner+w=401wt.eu-S1756062AbYJXL72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062AbYJXL72 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 07:59:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752307AbYJXL7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 07:59:20 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:57769 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206AbYJXL7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 07:59:19 -0400
Date: Fri, 24 Oct 2008 14:01:03 +0200
From: Pavel Machek <pavel@suse.cz>
To: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Richard Purdie <rpurdie@rpsys.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] SGI X86 UV: Provide a System Activity Indicator
	driver
Message-ID: <20081024120103.GD1680@elf.ucw.cz>
References: <4901AF28.4070606@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4901AF28.4070606@sgi.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2008-10-24 04:19:04, Mike Travis wrote:
> [Ingo - could you let me know what's holding up this driver?
> Thanks!, Mike]

I thought that...

 > +static __init void uv_scir_register_cpu_notifier(void)
> +{
> +	hotcpu_notifier(uv_scir_cpu_notify, 0);
> +	idle_notifier_register(&uv_idle_notifier);
> +}

...Ingo said that idle_notifier_register is deprecated and going away?

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
