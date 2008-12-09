Return-Path: <linux-kernel-owner+w=401wt.eu-S1755245AbYLIVAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245AbYLIVAY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 16:00:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753543AbYLIVAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 16:00:10 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41049 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751073AbYLIVAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 16:00:09 -0500
Date: Tue, 9 Dec 2008 20:59:49 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
       Jeff Garzik <jgarzik@redhat.com>,
       Alexandru Romanescu <a_romanescu@yahoo.co.uk>,
       Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/2] DMI: add dmi_match
Message-ID: <20081209205949.4c40ebee@lxorguk.ukuu.org.uk>
In-Reply-To: <1228855948-22886-1-git-send-email-jirislaby@gmail.com>
References: <493E0689.6020302@garzik.org>
	<1228855948-22886-1-git-send-email-jirislaby@gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> +static inline bool dmi_match(enum dmi_field f, const char *str)
> +{
> +	const char *info = dmi_get_system_info(f);
> +
> +	if (info == NULL || str == NULL)
> +		return info == str;
> +
> +	return !strcmp(info, str);

Not sure it is worth inlining but its definitely better this way

ACK
