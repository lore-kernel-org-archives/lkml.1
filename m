Return-Path: <linux-kernel-owner+w=401wt.eu-S1763019AbXG2NEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763019AbXG2NEn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 09:04:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762301AbXG2NEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 09:04:08 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55633 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762243AbXG2NEG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 09:04:06 -0400
Message-ID: <46AC9021.7060807@redhat.com>
Date: Sun, 29 Jul 2007 21:03:29 +0800
From: Eugene Teo <eteo@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Neil Horman <nhorman@tuxdriver.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, jeremy@goop.org,
       martin.pitt@ubuntu.com, wwoods@redhat.com
Subject: Re: [PATCH 2/3] core_pattern: allow passing of arguments to user
 mode helper when core_pattern is a pipe
References: <20070727200746.GC18946@hmsreliant.homelinux.net>
In-Reply-To: <20070727200746.GC18946@hmsreliant.homelinux.net>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Horman wrote:
[...]
> +			/* core limit size */
> +			case 'c':
> +				rc = snprintf(out_ptr, out_end - out_ptr,
> +					      "%lu", current->signal->rlim[RLIMIT_CORE].rlim_cur); 

Trailing space.

[...]
> - 		if(call_usermodehelper_pipe(corename+1, NULL, NULL, &file)) {
> + 		if(call_usermodehelper_pipe(corename+1, helper_argv, NULL, &file)) {
   ^^^^^^^^^^^^^

Use tabs, and a missing space after '('.

Eugene
