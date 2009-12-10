Return-Path: <linux-kernel-owner+w=401wt.eu-S933970AbZLJLH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933970AbZLJLH6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 06:07:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760371AbZLJLHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 06:07:53 -0500
Received: from ozlabs.org ([203.10.76.45]:33095 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751684AbZLJLHx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 06:07:53 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH v2] modpost: fix asprintf warnings
Date: Thu, 10 Dec 2009 21:37:52 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-16-generic; KDE/4.3.2; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <20091209155903.GB3247@hack> <1260407779-12517-1-git-send-email-vapier@gentoo.org>
In-Reply-To: <1260407779-12517-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200912102137.52347.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Dec 2009 11:46:19 am Mike Frysinger wrote:
> On compilers with security warnings enabled by default, we get:
> 
> scripts/mod/modpost.c: In function 'get_markers':
> scripts/mod/modpost.c:1562: warning: ignoring return value of 'asprintf',
>                                      declared with attribute warn_unused_result
> scripts/mod/modpost.c: In function 'add_marker':
> scripts/mod/modpost.c:1982: warning: ignoring return value of 'asprintf',
>                                      declared with attribute warn_unused_result

Actually I think these warnings only occur with -DFORTIFY_SOURCE.  This is
turned on by Ubuntu at least.

I think they're a bad idea (if you really don't care, suppressing them is
really painful), but that's a separate battle...

Applied,
Rusty.
