Return-Path: <linux-kernel-owner+w=401wt.eu-S1758162AbXLRFOz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758162AbXLRFOz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 00:14:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751492AbXLRFOr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 00:14:47 -0500
Received: from ozlabs.org ([203.10.76.45]:59750 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751086AbXLRFOq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 00:14:46 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: Re: [PATCH 3/21] [PATCH] move desc_empty to where they belong
Date: Tue, 18 Dec 2007 16:14:36 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, glommer@gmail.com,
       tglx@linutronix.de, mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, ak@suse.de,
       chrisw@sous-sol.org, rostedt@goodmis.org, hpa@zytor.com,
       zach@vmware.com, roland@redhat.com
References: <11979319641796-git-send-email-gcosta@redhat.com> <11979319763641-git-send-email-gcosta@redhat.com> <11979319811234-git-send-email-gcosta@redhat.com>
In-Reply-To: <11979319811234-git-send-email-gcosta@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712181614.37890.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 December 2007 09:52:26 Glauber de Oliveira Costa wrote:
> +static inline int desc_empty(const void *ptr)
> +{
> +	const u32 *desc = ptr;
> +	return !(desc[0] | desc[1]);
> +}

Erk. This really needs to be a union, not a void *.  I guess we can clean it 
later.

Rusty.
