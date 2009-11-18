Return-Path: <linux-kernel-owner+w=401wt.eu-S932359AbZKRSYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932359AbZKRSYf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 13:24:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932345AbZKRSYe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 13:24:34 -0500
Received: from smtp-out.google.com ([216.239.33.17]:11373 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932242AbZKRSYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 13:24:31 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=CxlacluP/sCl7a9najLypSaKQ4mBEREX1RQ1o70M2NfBD8fGbktXSk0hdEmzM6WBF
	rSVcjaO1EBdV4keDaVzJQ==
MIME-Version: 1.0
In-Reply-To: <1258536293-7762-18-git-send-email-jblunck@suse.de>
References: <1258536293-7762-1-git-send-email-jblunck@suse.de>
	 <1258536293-7762-18-git-send-email-jblunck@suse.de>
Date: Wed, 18 Nov 2009 10:24:30 -0800
Message-ID: <6599ad830911181024l5a4d534cs608409f1d42eed26@mail.gmail.com>
Subject: Re: [PATCH 17/20] BKL: Remove BKL from cgroup
From: Paul Menage <menage@google.com>
To: Jan Blunck <jblunck@suse.de>
Cc: linux-fsdevel@vger.kernel.org,
       Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, jkacur@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
       matthew@wil.cx, Li Zefan <lizf@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 18, 2009 at 1:24 AM, Jan Blunck <jblunck@suse.de> wrote:
> The BKL is only used in remount_fs and get_sb that are both protected by
> the superblocks s_umount rw_semaphore. Therefore it is safe to remove the
> BKL entirely.
>
> Signed-off-by: Jan Blunck <jblunck@suse.de>

Acked-by: Paul Menage <menage@google.com>
