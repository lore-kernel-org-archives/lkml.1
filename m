Return-Path: <linux-kernel-owner+w=401wt.eu-S1754123AbZAKUWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123AbZAKUWx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 15:22:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752136AbZAKUWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 15:22:44 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44303 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbZAKUWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 15:22:44 -0500
To: Tomas Szepe <szepe@pinerecords.com>
Cc: arodland@noln.com, jbglaw@lug-owl.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Morse code panics for 2.6.29-rc1
From: Andi Kleen <andi@firstfloor.org>
References: <20090111190503.GA20861@louise.pinerecords.com>
Date: Sun, 11 Jan 2009 21:22:17 +0100
In-Reply-To: <20090111190503.GA20861@louise.pinerecords.com> (Tomas Szepe's message of "Sun, 11 Jan 2009 20:05:03 +0100")
Message-ID: <87y6xhfv9i.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tomas Szepe <szepe@pinerecords.com> writes:
> +
> +static inline unsigned char tomorse(char c) {
> +	if (c >= 'a' && c <= 'z')
> +		c -= 'a' - 'A';

It's not widely known, but the kernel actually has a
fully usable ctype.h

-Andi
-- 
ak@linux.intel.com
