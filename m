Return-Path: <linux-kernel-owner+w=401wt.eu-S1754465AbYADRNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754465AbYADRNd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 12:13:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751943AbYADRN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 12:13:26 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:43289 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752128AbYADRNZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 12:13:25 -0500
Date: Fri, 4 Jan 2008 18:13:26 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
Cc: mingo@helte.hu, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] profile: further Codying Style fixes
Message-ID: <20080104171326.GA31382@uranus.ravnborg.org>
References: <20080104152521.620e4e80@paolo-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080104152521.620e4e80@paolo-desktop>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -408,9 +406,8 @@ void profile_hits(int type, void *__pc, unsigned int nr_hits)
>  	pc = ((unsigned long)__pc - (unsigned long)_stext) >> prof_shift;
>  	atomic_add(nr_hits, &prof_buffer[min(pc, prof_len - 1)]);
>  }
> -#endif /* !CONFIG_SMP */
> -
>  EXPORT_SYMBOL_GPL(profile_hits);
> +#endif /* !CONFIG_SMP */

The symbol is now not exported for non-SMP builds which is a change in functionality.
And thats not acceptable for pure clean-up patches.

	Sam
