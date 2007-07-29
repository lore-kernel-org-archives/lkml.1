Return-Path: <linux-kernel-owner+w=401wt.eu-S1763136AbXG2NE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763136AbXG2NE3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 09:04:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762210AbXG2NEE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 09:04:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55607 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761986AbXG2NEB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 09:04:01 -0400
Message-ID: <46AC9017.7080109@redhat.com>
Date: Sun, 29 Jul 2007 21:03:19 +0800
From: Eugene Teo <eteo@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Neil Horman <nhorman@tuxdriver.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, jeremy@goop.org,
       martin.pitt@ubuntu.com, wwoods@redhat.com
Subject: Re: [PATCH 1/3] core_pattern: ignore RLIMIT_CORE if core_pattern
 is a pipe
References: <20070727200355.GB18946@hmsreliant.homelinux.net>
In-Reply-To: <20070727200355.GB18946@hmsreliant.homelinux.net>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Horman wrote:
[...]
> +	 * Don't bother to check the RLIMIT_CORE value if core_pattern points
> +	 * to a pipe.  Since we're not writing directly to the filesystem
> +	 * RLIMIT_CORE doesn't really apply, as no actual core file will be
> +	 * created unless the pipe reader choses to write out the core file
> +	 * at which point file size limits and permissions will be imposed 
                                                                          ^^^
Trailing space.

Eugene
