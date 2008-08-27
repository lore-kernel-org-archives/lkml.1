Return-Path: <linux-kernel-owner+w=401wt.eu-S1758034AbYH0OMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758034AbYH0OMt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 10:12:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756196AbYH0OMh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 10:12:37 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:48837 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755997AbYH0OMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 10:12:35 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Serge Hallyn <serue@us.ibm.com>
Subject: Re: [PATCH 26/59] CRED: Wrap task credential accesses in the FAT filesystem
References: <20080827134541.19980.61042.stgit@warthog.procyon.org.uk>
	<20080827134756.19980.73543.stgit@warthog.procyon.org.uk>
Date: Wed, 27 Aug 2008 23:12:29 +0900
In-Reply-To: <20080827134756.19980.73543.stgit@warthog.procyon.org.uk> (David
	Howells's message of "Wed, 27 Aug 2008 14:47:56 +0100")
Message-ID: <87d4ju8s36.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> writes:

> Wrap access to task credentials so that they can be separated more easily from
> the task_struct during the introduction of COW creds.
>
> Change most current->(|e|s|fs)[ug]id to current_(|e|s|fs)[ug]id().
>
> Change some task->e?[ug]id to task_e?[ug]id().  In some places it makes more
> sense to use RCU directly rather than a convenient wrapper; these will be
> addressed by later patches.
>
> Signed-off-by: David Howells <dhowells@redhat.com>
> Reviewed-by: James Morris <jmorris@namei.org>
> Acked-by: Serge Hallyn <serue@us.ibm.com>
> Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

Thanks. Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
