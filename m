Return-Path: <linux-kernel-owner+w=401wt.eu-S1755231AbZJJW5h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231AbZJJW5h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 18:57:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754989AbZJJW5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 18:57:36 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37157 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754798AbZJJW5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 18:57:36 -0400
Date: Sat, 10 Oct 2009 23:58:22 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bernhard Walle <bernhard@bwalle.de>
Cc: akpm@linuxfoundation.org, linux-kernel@vger.kernel.org,
       Bernhard Walle <bernhard@bwalle.de>
Subject: Re: [PATCH 2/5] Add setter/getter interface for kmsg_redirect
Message-ID: <20091010235822.3a7992dd@lxorguk.ukuu.org.uk>
In-Reply-To: <1255207870-24496-3-git-send-email-bernhard@bwalle.de>
References: <1255207870-24496-1-git-send-email-bernhard@bwalle.de>
	<1255207870-24496-3-git-send-email-bernhard@bwalle.de>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +int vt_get_kmsg_redirect(void)
> +{
> +	return kmsg_redirect;
> +}

Explain the locking rules

> +#ifdef CONFIG_VT_CONSOLE
> +
> +extern void vt_set_kmsg_redirect(int vt);
> +extern int  vt_get_kmsg_redirect(void);

Just make them extern inline, its a one liner.
