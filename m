Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965619Ab0BZSA7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 13:00:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57313 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965482Ab0BZSA6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 13:00:58 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100225181500.GA18008@redhat.com>
References: <20100225181500.GA18008@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Neil Horman <nhorman@tuxdriver.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 1/2] umh && creds: convert call_usermodehelper_keys() to use subprocess_info->init()
Date: Fri, 26 Feb 2010 18:00:38 +0000
Message-ID: <16951.1267207238@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> wrote:

> +	/*
> +	 * This is called in context of freshly forked kthread before
> +	 * kernel_execve(), we can just change our ->session_keyring.
> +	 */

Ummmm....  What gives you that idea?

You may be sharing init_cred...

You need to create, modify and commit a new set of creds.

David
