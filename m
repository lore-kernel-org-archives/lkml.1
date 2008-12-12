Return-Path: <linux-kernel-owner+w=401wt.eu-S1757920AbYLLPBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757920AbYLLPBc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 10:01:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756578AbYLLPBW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 10:01:22 -0500
Received: from yx-out-2324.google.com ([74.125.44.29]:24248 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbYLLPBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 10:01:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=DlJVlSFPwpxyogtiNZvGNZPYa+aMAb7/IlR6YhURWDkZTpw3703LVfgXmdHWKNOuZH
         sip4MM1Nmy3p9kZVspMOFfseY0/xBoj1IfYp0MpVhbypS5/e4wX9OHsiRPk+z07tqaV/
         IJjCTzH96NCqoL7upsOKpTm0rah5EdlbYAkxc=
Message-ID: <b9df5fa10812120701q72bdcc3cue59e22bb2c295ee0@mail.gmail.com>
Date: Fri, 12 Dec 2008 21:01:20 +0600
From: "Rakib Mullick" <rakib.mullick@gmail.com>
To: "Pavel Machek" <pavel@suse.cz>
Subject: Re: [PATCH] kernel/freezer.c : Removing extra checking.
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux-kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20081211123152.GA1842@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b9df5fa10812060020i40373ed3rdc97812ed46ba959@mail.gmail.com>
	 <200812061441.15772.rjw@sisk.pl>
	 <b9df5fa10812060704t1685710aw65f7c1e00e5f98@mail.gmail.com>
	 <200812061752.58008.rjw@sisk.pl> <20081211123152.GA1842@ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/08, Pavel Machek <pavel@suse.cz> wrote:
>
> Plus this looks like infinite loop after your change. Have you tested
>  it?
No. I haven't tested it. But very soon I'll try to test it.
Well, you said pending signal. What will happen when a pending signal
will send. In current code check is made to make sure that the task is
frozen or not. I mean , when a signal is send ( from theoritical POV,
which could be any ) this code doesn't make sure what will happen to
that perticular process.
It is already a infinite loop, the check is made to make sure that
whether the task will be scheduled or not.

Thanks,
Rakib

>
>
>  --
>  (english) http://www.livejournal.com/~pavelmachek
>  (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
>
