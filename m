Return-Path: <linux-kernel-owner+w=401wt.eu-S1754149AbYH3PEP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149AbYH3PEP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 11:04:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752263AbYH3PD5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 11:03:57 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:55551 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751610AbYH3PD4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 11:03:56 -0400
Date: Sun, 31 Aug 2008 00:03:57 +0900 (JST)
Message-Id: <20080831.000357.70223885.anemo@mba.ocn.ne.jp>
To: david@fries.net
Cc: linux-kernel@vger.kernel.org, p_gortmaker@yahoo.com,
       netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] ne.c fix for hibernate and rmmod oops fix
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <20080830024425.GA24929@spacedout.fries.net>
References: <20080830024425.GA24929@spacedout.fries.net>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Aug 2008 21:44:25 -0500, David Fries <david@fries.net> wrote:
> +	if (!strcmp(res->name, BAD_STR))
> +		dev->mem_end = BAD;

The res->name might be NULL.  You should check it first.

	if (res->name && !strcmp(res->name, BAD_STR))
		dev->mem_end = BAD;

---
Atsushi Nemoto
