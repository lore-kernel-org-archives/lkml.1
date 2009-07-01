Return-Path: <linux-kernel-owner+w=401wt.eu-S1755205AbZGAQNE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205AbZGAQNE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 12:13:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752428AbZGAQMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 12:12:55 -0400
Received: from outbound-mail-118.bluehost.com ([69.89.22.18]:56737 "HELO
	outbound-mail-118.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752188AbZGAQMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 12:12:55 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=ahnkr0+l2PgU3OUdkUyOfO2s8y5RgwOfjmNAlp8PXfyIfwT9hhpfyd0IfIYgslhQke5LwvIM+rDwSEc3lublL1g5kZePqXZ0oqUTtL3TMq35hhgo+Is8v5XsTHJfstaE;
Date: Wed, 1 Jul 2009 09:12:55 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Andy Whitcroft <apw@canonical.com>
Cc: Dave Airlie <airlied@linux.ie>, Eric Anholt <eric@anholt.net>,
       dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] i915: fix up a raw 64bit divide
Message-ID: <20090701091255.363f9d4d@jbarnes-g45>
In-Reply-To: <1246458059-15965-1-git-send-email-apw@canonical.com>
References: <1246458059-15965-1-git-send-email-apw@canonical.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.17.2; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  1 Jul 2009 15:20:59 +0100
Andy Whitcroft <apw@canonical.com> wrote:

> We are seeing compilation failures on i386 in some environments due
> to an undefined reference as below:
> 
>     ERROR: "__udivdi3" [drivers/gpu/drm/i915/i915.ko] undefined!
> 
> This is generated due to a raw 64 bit divide in the i915 driver.  Fix
> up this raw divide.
> 
> Signed-off-by: Andy Whitcroft <apw@canonical.com>

I think building with newer GCCs will prevent this error, but the fix
looks fine.

Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>

-- 
Jesse Barnes, Intel Open Source Technology Center
