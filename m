Return-Path: <linux-kernel-owner+w=401wt.eu-S1752966AbZKISVL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966AbZKISVL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 13:21:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752306AbZKISVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 13:21:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16452 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751688AbZKISVK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 13:21:10 -0500
Subject: Re: [PATCH] audit: Match SELinux context in "user" records
From: Eric Paris <eparis@redhat.com>
To: Miloslav =?UTF-8?Q?Trma=C4=8D?= <mitr@redhat.com>
Cc: viro@zeniv.linux.org.uk, linux-audit@redhat.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <1257779446-1395-1-git-send-email-mitr@redhat.com>
References: <1257779446-1395-1-git-send-email-mitr@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 Nov 2009 13:21:13 -0500
Message-Id: <1257790873.2994.25.camel@dhcp231-106.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-09 at 16:10 +0100, Miloslav Trmač wrote:
> From: Miloslav Trmac <mitr@redhat.com>
> 
> Add support for matching by security label (e.g. SELinux context) of
> the sender of an user-space audit record.
> 
> The audit filter code already allows user space to configure such
> filters, but they were ignored during evaluation.  This patch implements
> evaluation of these filters.
> 
> For example, after application of this patch, PAM authentication logs
> caused by cron can be disabled using
> 	auditctl -a user,never -F subj_type=crond_t
> 
> Signed-off-by: Miloslav Trmac <mitr@redhat.com>

I wish there was a way to stop sending these instead of dropping them
later, but the functionality itself is not a horrid idea and this isn't
a performance hot list (like the syscall list)  so.....

Acked-by: Eric Paris <eparis@redhat.com>

(I actually talked to Al about it already and he'll queue it up for the
next merge window)

