Return-Path: <linux-kernel-owner+w=401wt.eu-S1755361AbZJBL7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361AbZJBL7z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 07:59:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754456AbZJBL7y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 07:59:54 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:50689 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625AbZJBL7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 07:59:53 -0400
From: Oliver Neukum <oliver@neukum.org>
To: "Sven-Thorsten Dietrich" <sdietrich@novell.com>
Subject: Re: [PATCH][UHCI-DEBUG] Don't kmalloc with BKL held
Date: Fri, 2 Oct 2009 14:01:36 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.31-rc9-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
       "linux-rt-users" <linux-rt-users@vger.kernel.org>
References: <1254474744.28661.2.camel@sven.thebigcorporation.com>
In-Reply-To: <1254474744.28661.2.camel@sven.thebigcorporation.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910021401.37997.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 2. Oktober 2009 11:12:24 schrieb Sven-Thorsten Dietrich:
> Subject: Don't kmalloc with BKL held.
> From: Sven-Thorsten Dietrich <sdietrich@suse.de>
>
> I'm eyeballing this file for complete removal of lock_kernel but
> at first glance, we definitely don't need BKL to kmalloc().

The reasoning is correct, but this patch screws up the error case.
You also need to move the label.

	Regards
		Oliver

