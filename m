Return-Path: <linux-kernel-owner+w=401wt.eu-S1763393AbXG2NE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763393AbXG2NE7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 09:04:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762939AbXG2NEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 09:04:15 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55682 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762924AbXG2NEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 09:04:14 -0400
Message-ID: <46AC9027.3070306@redhat.com>
Date: Sun, 29 Jul 2007 21:03:35 +0800
From: Eugene Teo <eteo@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Neil Horman <nhorman@tuxdriver.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, jeremy@goop.org,
       martin.pitt@ubuntu.com, wwoods@redhat.com
Subject: Re: [PATCH 3/3] core_pattern: fix up a few miscelaneous bugs
References: <20070727201357.GD18946@hmsreliant.homelinux.net>
In-Reply-To: <20070727201357.GD18946@hmsreliant.homelinux.net>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Horman wrote:
[...]
> +		delimit = strrchr(helper_argv[0], '/');
> +		if (delimit) 

Trailing space.

> +			delimit++;
> +		else
> +			delimit = helper_argv[0];
> +		if (!strcmp(delimit, current->comm))
> +		{	

Trailing space, and '{' should be after '...comm))'.

Eugene
