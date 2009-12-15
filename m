Return-Path: <linux-kernel-owner+w=401wt.eu-S1754836AbZLOPYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836AbZLOPYR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 10:24:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754128AbZLOPYQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 10:24:16 -0500
Received: from mail.perches.com ([173.55.12.10]:1190 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753883AbZLOPYQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 10:24:16 -0500
Subject: Re: [PATCH] quota: integer constant is too large for
 =?UTF-8?Q?=E2=80=98long=E2=80=99?= type in
From: Joe Perches <joe@perches.com>
To: Jerry Leo <jerryleo860202@gmail.com>
Cc: jack@suse.cz, linux-kernel@vger.kernel.org
In-Reply-To: <6304b52b0912150527v48056ccam8d1c318bcd7e085b@mail.gmail.com>
References: <6304b52b0912150527v48056ccam8d1c318bcd7e085b@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Dec 2009 07:24:14 -0800
Message-ID: <1260890654.18538.123.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-15 at 21:27 +0800, Jerry Leo wrote:
> -               info->dqi_maxblimit = 0xffffffffffffffff;       /* 2^64-1 */
> -               info->dqi_maxilimit = 0xffffffffffffffff;
> +               info->dqi_maxblimit = 0xFFFFFFFFFFFFFFFFLL;     /* 2^64-1 */
> +               info->dqi_maxilimit = 0xFFFFFFFFFFFFFFFFLL;

ULLONG_MAX?


