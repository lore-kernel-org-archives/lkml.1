Return-Path: <linux-kernel-owner+w=401wt.eu-S1763267AbYCGMdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763267AbYCGMdR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 07:33:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757063AbYCGMdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 07:33:04 -0500
Received: from ns2.suse.de ([195.135.220.15]:58048 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756657AbYCGMdD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 07:33:03 -0500
From: Andreas Schwab <schwab@suse.de>
To: Laurent Vivier <Laurent.Vivier@bull.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH][v2] Modify loop device to be able to manage partitions of the disk image
References: <12048928601734-git-send-email-Laurent.Vivier@bull.net>
X-Yow: All I can think of is a platter of organic PRUNE CRISPS being trampled
 by an army of swarthy, Italian LOUNGE SINGERS...
Date: Fri, 07 Mar 2008 13:33:00 +0100
In-Reply-To: <12048928601734-git-send-email-Laurent.Vivier@bull.net> (Laurent
	Vivier's message of "Fri\, 7 Mar 2008 13\:27\:40 +0100")
Message-ID: <jepru6n283.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Laurent Vivier <Laurent.Vivier@bull.net> writes:

> +static int __init max_part_setup(char *str)
> +{
> +	loop_max_part = simple_strtol(str, NULL, 0);
> +	if (loop_max_part > (1UL << (MINORBITS - 1))) {
> +		/* we must keep at least one bit for loop device number */
> +		printk(KERN_ERR
> +			"loop: loop_max_part cannot be greater than %d\n",
> +			1UL << (MINORBITS - 1));

Since the argument is of type unsigned long you should use %ld or %lu.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
