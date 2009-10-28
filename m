Return-Path: <linux-kernel-owner+w=401wt.eu-S1755204AbZJ1Qhr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204AbZJ1Qhr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 12:37:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755138AbZJ1Qhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 12:37:46 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36352 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755161AbZJ1Qhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 12:37:46 -0400
Date: Wed, 28 Oct 2009 16:37:49 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [PATCH] Fix some AB3100 regulator issues
Message-ID: <20091028163749.GA27459@rakim.wolfsonmicro.main>
References: <1256747415-18486-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1256747415-18486-1-git-send-email-linus.walleij@stericsson.com>
X-Cookie: Be careful!  Is it classified?
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 28, 2009 at 05:30:15PM +0100, Linus Walleij wrote:

>  	 * system is shut down. So this is handled specially.
>  	 */
> +	pr_info("Called ab3100_disable_regulator\n");

This looks like debug trace which shouldn't be here.  Otherwise the
patch looks OK.
