Return-Path: <linux-kernel-owner+w=401wt.eu-S1761364AbYESTuN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761364AbYESTuN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 15:50:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756914AbYESTuB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 15:50:01 -0400
Received: from el-out-1112.google.com ([209.85.162.178]:10470 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756717AbYESTuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 15:50:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=a8lH4kiN+/ca4xox+X4Lu2xPUEax7jzBQJ/57k9cn9QByB+OiJ4id7A2nkZFm6b1EYL4N5vKrP34J54KsrtC9zD6bZLlbdPVnF5Tk4V//KVwkoNCIsPdyB4UmvFhODVu7A1FAdQxJRmquiM+N8Pj5qGoJedtaY6pocQ2Dnp8Eic=
Date: Tue, 20 May 2008 00:45:35 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Shawn Starr <shawn.starr@rogers.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Modern 2.6 kernels - Notification for changing hostname from
	proc/sys/kernel/hostname ?
Message-ID: <20080519204535.GA23629@martell.zuzino.mipt.ru>
References: <200805191316.12424.shawn.starr@rogers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805191316.12424.shawn.starr@rogers.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2008 at 01:16:12PM -0400, Shawn Starr wrote:
> I was looking at utsname_sysctl.c (if this is the right place) and noticed 
> there doesn't seem to be any notification via the connector bus to tell 
> userspace the hostname has changed? Is this correct?

Yes. No notifications.

> if so, would not not make sense to add such event triggers so that things like 
> KDE would not have to poll to determine if the hostname changes and instead 
> had D-BUS tell userspace the hostname changed?

Why does it want to know if and when hostname changes?

> Perhaps this could be applied to other values (where applicable) 
> in /proc/sys/kernel?

Probably, what other stuff desktop crowd wants?

> Or is this all going to go into sysfs eventually (where some of this really 
> might belong)

Hopefully, not. There is already uname(2), sysctls -- proc and binary,

