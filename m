Return-Path: <linux-kernel-owner+w=401wt.eu-S1757262AbXLSX30@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757262AbXLSX30 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 18:29:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753688AbXLSX3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 18:29:15 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:60749 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753538AbXLSX3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 18:29:14 -0500
Date: Thu, 20 Dec 2007 00:29:12 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Eric Paris <eparis@redhat.com>
cc: linux-kernel@vger.kernel.org, jmorris@namei.org, alan@redhat.com,
       chrisw@redhat.com, akpm@linux-foundation.org,
       linux-security-module@vger.kernel.org, solar@openwall.com,
       wtarreau@hera.kernel.org
Subject: Re: [PATCH] Allow Kconfig to set default mmap_min_addr protection
In-Reply-To: <1198101545.6197.52.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0712200027230.5524@fbirervta.pbzchgretzou.qr>
References: <1198101545.6197.52.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Dec 19 2007 16:59, Eric Paris wrote:
>
>+config SECURITY_DEFAULT_MMAP_MIN_ADDR
>+        int "Low address space to protect from user allocation"

Hm, should not this be 'hex'?

>+        depends on SECURITY
>+        default 0
>+        help
