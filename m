Return-Path: <linux-kernel-owner+w=401wt.eu-S1752890AbZKMNWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890AbZKMNWr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 08:22:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751765AbZKMNWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 08:22:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26200 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751410AbZKMNWk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 08:22:40 -0500
From: Andreas Schwab <schwab@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2.6.32] ftrace: fix event format export
References: <1258115870.6167.4.camel@johannes.local>
X-Yow: Yes, Private DOBERMAN!!
Date: Fri, 13 Nov 2009 14:22:28 +0100
In-Reply-To: <1258115870.6167.4.camel@johannes.local> (Johannes Berg's message
	of "Fri, 13 Nov 2009 13:37:50 +0100")
Message-ID: <m3y6mazhij.fsf@hase.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Berg <johannes@sipsolutions.net> writes:

> --- wireless-testing.orig/include/trace/ftrace.h	2009-11-13 13:15:21.000000000 +0100
> +++ wireless-testing/include/trace/ftrace.h	2009-11-13 13:34:03.000000000 +0100
> @@ -159,7 +159,7 @@
>  #undef __get_str
>  
>  #undef TP_printk
> -#define TP_printk(fmt, args...) "%s, %s\n", #fmt, __stringify(args)
> +#define TP_printk(fmt, args...) "\"%s\", %s\n", fmt, __stringify(args)

Would using __stringify(fmt) work?  If there are double quote characters
in fmt your solution would produce output that is ambiguous.

Andreas.

-- 
Andreas Schwab, schwab@redhat.com
GPG Key fingerprint = D4E8 DBE3 3813 BB5D FA84  5EC7 45C6 250E 6F00 984E
"And now for something completely different."
