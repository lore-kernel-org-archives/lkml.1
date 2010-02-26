Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966092Ab0BZUm7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 15:42:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29938 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966073Ab0BZUm6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 15:42:58 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100226200357.GB16092@redhat.com>
References: <20100226200357.GB16092@redhat.com> <20100226182325.GA31674@redhat.com> <20100225181500.GA18008@redhat.com> <16951.1267207238@redhat.com> <17603.1267209668@redhat.com> <20100226200313.GA16092@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Neil Horman <nhorman@tuxdriver.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 -mm 1/2] umh && creds: convert call_usermodehelper_keys() to use subprocess_info->init()
Date: Fri, 26 Feb 2010 20:42:38 +0000
Message-ID: <23363.1267216958@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> wrote:

> +static inline int
> +call_usermodehelper_keys(char *path, char **argv, char **envp,
> +			 struct key *session_keyring, enum umh_wait wait)

You should get rid of the inline there.  I think it's okay otherwise.

David
