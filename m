Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254Ab0CHNUJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 08:20:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10113 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753955Ab0CHNUF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 08:20:05 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100305231054.GB22614@redhat.com>
References: <20100305231054.GB22614@redhat.com> <20100226205300.GA26171@redhat.com> <20100226200357.GB16092@redhat.com> <20100226182325.GA31674@redhat.com> <20100225181500.GA18008@redhat.com> <16951.1267207238@redhat.com> <17603.1267209668@redhat.com> <20100226200313.GA16092@redhat.com> <23363.1267216958@redhat.com> <29907.1267226649@redhat.com> <20100305225243.GA21790@redhat.com> 
To: Oleg Nesterov <oleg@redhat.com>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Neil Horman <nhorman@tuxdriver.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH,RESEND -mm 2/2] umh && creds: kill subprocess_info->cred logic
Date: Mon, 08 Mar 2010 13:19:45 +0000
Message-ID: <19935.1268054385@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> wrote:

> Now that nobody ever changes subprocess_info->cred we can kill this
> member and related code. ____call_usermodehelper() always runs in the
> context of freshly forked kernel thread, it has the proper ->cred
> copied from its parent kthread, keventd.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> Acked-by: Neil Horman <nhorman@tuxdriver.com>

Acked-by: David Howells <dhowells@redhat.com>
