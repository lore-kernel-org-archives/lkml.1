Return-Path: <linux-kernel-owner+w=401wt.eu-S1753505AbYAXA6B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505AbYAXA6B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 19:58:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752359AbYAXA5x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 19:57:53 -0500
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2711 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752159AbYAXA5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 19:57:53 -0500
Subject: Re: [PATCH][ppc] logical/bitand typo in powerpc/boot/4xx.c
From: Joe Perches <joe@perches.com>
To: Roel Kluin <12o3l@tiscali.nl>
Cc: Andy Whitcroft <apw@shadowen.org>, jwboyer@linux.vnet.ibm.com,
       lkml <linux-kernel@vger.kernel.org>,
       linuxppc-dev <linuxppc-dev@ozlabs.org>
In-Reply-To: <4797D968.1030101@tiscali.nl>
References: <4797C1AD.3040307@tiscali.nl>
	 <1201129527.4988.69.camel@localhost>  <4797D968.1030101@tiscali.nl>
Content-Type: text/plain
Date: Wed, 23 Jan 2008 16:39:36 -0800
Message-Id: <1201135176.4988.80.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-01-24 at 01:18 +0100, Roel Kluin wrote:
> when you use git-grep -n "\(&&\|||\)${s}0x\([A-Z0-9]*\|[a-z0-9]*\)",
> (with s="[[:space:]]*") there will be false positives []
> so i'd propose to change that to
> +# Check for bitwise tests written as boolean
> +		if ($line =~ /(?:(?:\(|\&\&|\|\|)\s*0[xX]\s*(?:&&|\|\|)|
> +				(?:\&\&|\|\|)\s*0[xX]\s*(?:\)|&&|\|\|))/) {
> +			WARN("boolean test with hexadecimal, perhaps just 1 \& or \|?\n" . $herecurr);
> +		}
> +

All 13 false positives are "hex_constant logical_test variable".
I think that Linus would say that they are all poor style.

Still, fine by me.  cheers, Joe


