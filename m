Return-Path: <linux-kernel-owner+w=401wt.eu-S1757194AbXD0UUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757194AbXD0UUx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 16:20:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757193AbXD0UUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 16:20:52 -0400
Received: from gw.goop.org ([64.81.55.164]:36285 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757192AbXD0UUU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 16:20:20 -0400
Message-ID: <46325B02.20106@goop.org>
Date: Fri, 27 Apr 2007 13:20:18 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Gautham R Shenoy <ego@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Oleg Nesterov <oleg@tv-sign.ru>, Pavel Machek <pavel@ucw.cz>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm 1/2] Separate freezer from PM code
References: <200704271737.31192.rjw@sisk.pl> <200704271738.48429.rjw@sisk.pl> <463223E9.7050705@goop.org> <200704272220.57786.rjw@sisk.pl>
In-Reply-To: <200704272220.57786.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> Makes sense.  Please have a look at the updated patch below.
>
> Sam, does this one look better to you?
>   

If freezer.c is in kernel/, then shouldn't the corresponding config var
be in a non-arch Kconfig file?

    J
