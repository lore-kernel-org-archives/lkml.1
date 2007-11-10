Return-Path: <linux-kernel-owner+w=401wt.eu-S1753501AbXKJQuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501AbXKJQuY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 11:50:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752953AbXKJQuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 11:50:11 -0500
Received: from main.gmane.org ([80.91.229.2]:50332 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752937AbXKJQuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 11:50:09 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: "Alexander E. Patrakov" <patrakov@gmail.com>
Subject: Re: [PATCH] Include header required for INT_MAX
Date: Sat, 10 Nov 2007 21:48:50 +0500
Message-ID: <fh4ndi$t0i$1@ger.gmane.org>
References: <20071110145627.C6FE347A7C@mail.koeller.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 90.150.237.183
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); ru-RU; rv:1.8.0.13pre) Gecko/20070505 Iceape/1.0.9 (Debian-1.0.10~pre070720-0etch3+lenny1) Mnenhy/0.7.5.666
In-Reply-To: <20071110145627.C6FE347A7C@mail.koeller.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Koeller wrote:
> cdrom.h uses INT_MAX, so it must include kernel.h or
> limits.h (userspace) for a definition.

No, it must be fixed so that it doesn't use this #defined constant. Debian has this:

/* Special codes used when specifying changer slots. */
#define CDSL_NONE               ((int) (~0U>>1)-1)
#define CDSL_CURRENT            ((int) (~0U>>1))

-- 
Alexander E. Patrakov

