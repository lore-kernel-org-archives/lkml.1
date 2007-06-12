Return-Path: <linux-kernel-owner+w=401wt.eu-S1757910AbXFLFeN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757910AbXFLFeN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 01:34:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753510AbXFLFd7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 01:33:59 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:48141 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752450AbXFLFd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 01:33:58 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Shani Moideen <shani.moideen@wipro.com>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       kernel-janitors@lists.osdl.org
Subject: Re: [KJ PATCH] Replacing memcpy(dest,src,PAGE_SIZE) with copy_page(dest,src) in arch/i386/kernel/machine_kexec.c
References: <1181616342.2282.8.camel@shani-win>
Date: Mon, 11 Jun 2007 23:32:03 -0600
In-Reply-To: <1181616342.2282.8.camel@shani-win> (Shani Moideen's message of
	"Tue, 12 Jun 2007 08:15:41 +0530")
Message-ID: <m1vedtpwks.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Shani Moideen <shani.moideen@wipro.com> writes:

> Hi,
> Replacing memcpy(dest,src,PAGE_SIZE) with copy_page(dest,src) in
> arch/i386/kernel/machine_kexec.c.

Please no.

People get creative in copy_page (especially mmx_copy_page),
and this code path need something simple and stupid, that
will work every time, especially when things are messed up
elsewhere.

Ideally we would actually do all of the setup before this point.
but that is another issue entirely.

Eric
