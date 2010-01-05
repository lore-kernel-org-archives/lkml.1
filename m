Return-Path: <linux-kernel-owner+w=401wt.eu-S1754996Ab0AEPvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754996Ab0AEPvQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 10:51:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754987Ab0AEPvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 10:51:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51410 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754980Ab0AEPvH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 10:51:07 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1262602095-17591-1-git-send-email-jslaby@suse.cz>
References: <1262602095-17591-1-git-send-email-jslaby@suse.cz> <4B41C750.9080305@gmail.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: dhowells@redhat.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       nhorman@tuxdriver.com, mingo@elte.hu,
       Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>
Subject: Re: [PATCH 1/3] SECURITY: selinux, fix update_rlimit_cpu parameter
Date: Tue, 05 Jan 2010 15:50:36 +0000
Message-ID: <17729.1262706636@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby <jslaby@suse.cz> wrote:

> From: Jiri Slaby <jirislaby@gmail.com>
> 
> Don't pass current RLIMIT_RTTIME to update_rlimit_cpu() in
> selinux_bprm_committing_creds, since update_rlimit_cpu expects
> RLIMIT_CPU limit.
> 
> Use proper rlim[RLIMIT_CPU].rlim_cur instead to fix that.
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> Acked-by: James Morris <jmorris@namei.org>
> Cc: Stephen Smalley <sds@tycho.nsa.gov>
> Cc: Eric Paris <eparis@parisplace.org>

Acked-by: David Howells <dhowells@redhat.com>
