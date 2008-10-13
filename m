Return-Path: <linux-kernel-owner+w=401wt.eu-S1759076AbYJMKh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759076AbYJMKh3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 06:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754809AbYJMKhP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 06:37:15 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53710 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754450AbYJMKhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 06:37:12 -0400
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] tty: remove the BKL in n_tty.c
From: Andi Kleen <andi@firstfloor.org>
References: <20081013084719.03972D1B9DE@perso1.free.fr>
Date: Mon, 13 Oct 2008 12:37:10 +0200
In-Reply-To: <20081013084719.03972D1B9DE@perso1.free.fr> (Frederic Weisbecker's message of "Mon, 13 Oct 2008 10:47:18")
Message-ID: <874p3gsrvt.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker <fweisbec@gmail.com> writes:
>  
> +
> +/*
> + * This Mutex is used to replace a big kernel lock that protected
> + * the access to tty->column.
> + */
> +static DEFINE_MUTEX(tty_column_mutex);

I suppose Alan did it already, but the general rule when doing
such changes is to lock data not code.

-Andi

-- 
ak@linux.intel.com
