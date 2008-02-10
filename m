Return-Path: <linux-kernel-owner+w=401wt.eu-S1756054AbYBJWMG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054AbYBJWMG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 17:12:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752371AbYBJWLm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 17:11:42 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:49841 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181AbYBJWLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 17:11:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=RCddKsuYwU/rpE0NGvOr5LH1wtm3pGlT3E45z6dB2/0lGwbiaCqcDzHTZNRbD0klSd0qTyfwNEgeWqKg9v2OxBqOXnmgp4XkKLGK7ToB+q0zBmijN3bRQpWjyu+kvHxo58pf7Dq/I8Pc8hnsRNc5YXiZacmLBsf2+x10iU4oMR4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jan Kiszka <jan.kiszka@web.de>
Subject: Re: [patch] kgdb light, v6
Date: Sun, 10 Feb 2008 23:14:19 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: Ingo Molnar <mingo@elte.hu>, Christoph Hellwig <hch@infradead.org>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@zip.com.au>, Thomas Gleixner <tglx@linutronix.de>,
       Jason Wessel <jason.wessel@windriver.com>
References: <20080210071331.GC3851@elte.hu> <20080210210900.GA27162@elte.hu> <47AF707C.6050305@web.de>
In-Reply-To: <47AF707C.6050305@web.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802102314.19500.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 10 February 2008, Jan Kiszka wrote:
> Ingo Molnar wrote:
> > * Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> >>> +static int init_kgdboc(void)
> >> __init
> > 
> > done.
> 
> Uuh, careful. We need this for runtime reconfiguration.

it is used only for 'module_init(init_kgdboc);' in v6
