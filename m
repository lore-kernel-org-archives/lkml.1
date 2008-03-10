Return-Path: <linux-kernel-owner+w=401wt.eu-S1752706AbYCJPaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706AbYCJPaZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 11:30:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751034AbYCJPaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 11:30:14 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:1188 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1750968AbYCJPaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 11:30:12 -0400
Subject: Re: [PATCH 1/5] lib: introduce call_once()
From: Joe Perches <joe@perches.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <20080310145704.GA6396@APFDCB5C>
References: <20080310145704.GA6396@APFDCB5C>
Content-Type: text/plain
Date: Mon, 10 Mar 2008 08:29:00 -0700
Message-Id: <1205162940.656.152.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3-1.2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-03-10 at 23:57 +0900, Akinobu Mita wrote:
> +++ 2.6-rc/include/linux/once.h
> +struct once_control {
> +	struct mutex lock;
> +	int done;

bool?

> +};
> +
> +#define __ONCE_INITIALIZER(name) {					\
> +		.lock		= __MUTEX_INITIALIZER(name.lock),	\
> +		.done		= 0,					\
> +	}
> +
> +#define DEFINE_ONCE(name) struct once_control name = __ONCE_INITIALIZER(name)

static?

> +
> +extern int call_once_slow(struct once_control *once_control,
> +			  int (*init_rouine)(void));

return bool?
spelling: s/rouine/routine/g


