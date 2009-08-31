Return-Path: <linux-kernel-owner+w=401wt.eu-S1751836AbZHaKj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751836AbZHaKj4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 06:39:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751425AbZHaKjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 06:39:55 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58221 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbZHaKjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 06:39:54 -0400
Date: Mon, 31 Aug 2009 12:39:49 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Siarhei Liakh <sliakh.lkml@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH V2] x86: NX protection for kernel data
Message-ID: <20090831103948.GA1353@ucw.cz>
References: <817ecb6f0908261020y2267218h8f435e8dc392f69a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <817ecb6f0908261020y2267218h8f435e8dc392f69a@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> --- a/init/main.c
> +++ b/init/main.c
> @@ -7,6 +7,8 @@
>   *  Added initrd & change_root: Werner Almesberger & Hans Lermen, Feb '96
>   *  Moan early if gcc is old, avoiding bogus kernels - Paul Gortmaker, May '96
>   *  Simplified starting of init:  Michael A. Griffith <grif@acm.org>
> + *  Data NX protection by Siarhei Liakh <sliakh.lkml@gmail.com>
> + *  and Xuxian Jiang <jiang@cs.ncsu.edu>
>   */

Better delete the changelog and add yourself to credits. Changelogs in
.c files are considered bad these days. (Feel free to kill the old
entries, too.)

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
