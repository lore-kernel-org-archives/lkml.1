Return-Path: <linux-kernel-owner+w=401wt.eu-S1760960AbZEZXqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760960AbZEZXqi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 19:46:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758369AbZEZXqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 19:46:30 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:58005 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757936AbZEZXqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 19:46:30 -0400
Date: Wed, 27 May 2009 08:46:16 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Greg Ungerer <gerg@uclinux.org>, uclinux-dev@uclinux.org,
       linux-mtd@lists.infradead.org
Subject: Re: [PATCH 1/3] mtd/maps: uclinux: allow systems to override map addr/size
Message-ID: <20090526234616.GC6295@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org,
	uclinux-dist-devel@blackfin.uclinux.org,
	Greg Ungerer <gerg@uclinux.org>, uclinux-dev@uclinux.org,
	linux-mtd@lists.infradead.org
References: <20090526231902.GA6295@linux-sh.org> <1243380798-10089-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243380798-10089-1-git-send-email-vapier@gentoo.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 26, 2009 at 07:33:16PM -0400, Mike Frysinger wrote:
> +extern char _ebss;
> +
Also, it would be nice if the remaining architectures that define _ebss
could shove this in their asm/sections.h so we can kill this off from the
driver itself.
