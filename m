Return-Path: <linux-kernel-owner+w=401wt.eu-S1763635AbZENXOA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763635AbZENXOA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 19:14:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762718AbZENXCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 19:02:55 -0400
Received: from outbound-mail-306.bluehost.com ([67.222.53.252]:39469 "HELO
	outbound-mail-306.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756909AbZENXCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 19:02:54 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=je4D4tD9Sd3H9DlMC7HEB3RrIFPqhvYV3oa0gjKyPqq9PWP9wpH3RSrEZtNcxWBa9nbxHOz/GYK3Ty8N1q1+qYy+LPWf0RF6mEq9MuTXVm+v4pO2D40Os6SXMdWyAsR3;
Date: Thu, 14 May 2009 16:02:51 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, eric@anholt.net,
       airlied@redhat.com, Randy Dunlap <randy.dunlap@oracle.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sysrq, intel_fb: fix sysrq g collision
Message-ID: <20090514160251.1772985e@jbarnes-g45>
In-Reply-To: <4A0CA203.7050907@windriver.com>
References: <4A0CA203.7050907@windriver.com>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 May 2009 17:58:11 -0500
Jason Wessel <jason.wessel@windriver.com> wrote:

> 
> This is patch is both a clean up and a regression fix because two
> things in the mainline kernel can register for sysrq-g, which is
> certainly a problem when you want to use both.
> 
> I talked to Randy and Jesse briefly about changing the intel fb video
> driver to use 'v' instead of 'g' and they agreed it would be ok to
> see a patch.  Hopefully each will ack this patch, or discuss it
> further.   If they ack the patch, I can send it on to Linus for
> consideration.
> 
> The long term intent here is to get mode switching with a generic
> kernel debug front end, with the short term intent to fix the sysrq
> collision.

Looks good, thanks Jason.

Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>

-- 
Jesse Barnes, Intel Open Source Technology Center
