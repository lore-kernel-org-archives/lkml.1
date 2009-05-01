Return-Path: <linux-kernel-owner+w=401wt.eu-S1755575AbZEAJIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575AbZEAJIk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 05:08:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754969AbZEAJIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 05:08:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36942 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754543AbZEAJIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 05:08:18 -0400
Date: Fri, 1 May 2009 01:59:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Philipp Reisner <philipp.reisner@linbit.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       Greg KH <gregkh@suse.de>, Neil Brown <neilb@suse.de>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Sam Ravnborg <sam@ravnborg.org>, Dave Jones <davej@redhat.com>,
       Nikanth Karthikesan <knikanth@suse.de>,
       "Lars Marowsky-Bree" <lmb@suse.de>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
       Kyle Moffett <kyle@moffetthome.net>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       Lars Ellenberg <lars.ellenberg@linbit.com>
Subject: Re: [PATCH 01/16] DRBD: major.h
Message-Id: <20090501015912.a16776da.akpm@linux-foundation.org>
In-Reply-To: <1241090812-13516-2-git-send-email-philipp.reisner@linbit.com>
References: <1241090812-13516-1-git-send-email-philipp.reisner@linbit.com>
	<1241090812-13516-2-git-send-email-philipp.reisner@linbit.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Apr 2009 13:26:37 +0200 Philipp Reisner <philipp.reisner@linbit.com> wrote:

> Since we have had a LANANA major number for years, and it is documented in devices.txt,
> I think that this first patch can go upstream without further changes.
> 
> Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
> Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
> 
> ---
> diff --git a/include/linux/major.h b/include/linux/major.h
> index 058ec15..6a8ca98 100644
> --- a/include/linux/major.h
> +++ b/include/linux/major.h
> @@ -145,6 +145,7 @@
>  #define UNIX98_PTY_MAJOR_COUNT	8
>  #define UNIX98_PTY_SLAVE_MAJOR	(UNIX98_PTY_MASTER_MAJOR+UNIX98_PTY_MAJOR_COUNT)
>  
> +#define DRBD_MAJOR		147
>  #define RTF_MAJOR		150
>  #define RAW_MAJOR		162

Yup.  I'll merge this, after having given it a vaguely useful title,
"drbd: add major number to major.h".
