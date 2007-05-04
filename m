Return-Path: <linux-kernel-owner+w=401wt.eu-S1031422AbXEDRWL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031422AbXEDRWL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 13:22:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031435AbXEDRWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 13:22:11 -0400
Received: from wr-out-0506.google.com ([64.233.184.227]:50799 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031422AbXEDRWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 13:22:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=KtQLaK2owwrxlZSmv00r8DuiPC1g4F8TObzkQQAzUwiZm1NqhGX+iztbnZSL3LgwlHVpxjX9jRY1KFIFm/0q+O7z92i8RONgJ5SekvpSw9XrhBobxgLICc3LXHa7Nf1jnbtBMsDpA5HbEnb0RdRwgJjSyZB2N4ipeDQuIVKkvio=
Message-ID: <a781481a0705041022jdc163fg20882d450338fb53@mail.gmail.com>
Date: Fri, 4 May 2007 22:52:08 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH -mm] PM: Separate hibernation code from suspend code
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Johannes Berg" <johannes@sipsolutions.net>,
       LKML <linux-kernel@vger.kernel.org>, "Pavel Machek" <pavel@ucw.cz>,
       "Nigel Cunningham" <nigel@nigel.suspend2.net>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>
In-Reply-To: <200705041132.32227.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200705041132.32227.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Trivial suggestions:

On 5/4/07, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> --- linux-2.6.21.orig/include/linux/suspend.h   2007-05-02 22:08:58.000000000 +0200
> +++ linux-2.6.21/include/linux/suspend.h        2007-05-03 15:22:24.000000000 +0200
> [...]
> +/**
> + * hibernation_set_ops - set the global hibernate operations
> + * @ops: the hibernation operations to use in subsequent hibernation transitions
> + */
> +extern void hibernation_set_ops(struct hibernation_ops *ops);

Comment must go near code, not with prototype in header.

> +/**
> + * hibernate - hibernate the system
> + */
> +extern int hibernate(void);

Pointless comment. You've already written a doc-book comment in the
code for this function anyway, so could just as well remove this.
