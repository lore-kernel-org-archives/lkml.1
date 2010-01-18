Return-Path: <linux-kernel-owner+w=401wt.eu-S1753591Ab0ARKWK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591Ab0ARKWK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 05:22:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752261Ab0ARKWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 05:22:08 -0500
Received: from one.firstfloor.org ([213.235.205.2]:60216 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661Ab0ARKWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 05:22:08 -0500
To: Arjan van de Ven <arjan@infradead.org>
Cc: Felix Rubinstein <felixru@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: /dev/mem implementation
From: Andi Kleen <andi@firstfloor.org>
References: <af0693f01001170847r49083075hc538a42b6bcd65ab@mail.gmail.com>
	<20100117094043.0483ee1a@infradead.org>
Date: Mon, 18 Jan 2010 11:22:04 +0100
In-Reply-To: <20100117094043.0483ee1a@infradead.org> (Arjan van de Ven's message of "Sun, 17 Jan 2010 09:40:43 -0800")
Message-ID: <87hbqj4ss3.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven <arjan@infradead.org> writes:
>
> If you feel that you have a valid use case where you really want do
> muck with such memory, it might be a good idea to explain that
> usecase....

To add to it this only applies to uncacheable pages which don't use
MTRRs. Unless in some special situations (e.g. a lot of GPU 3d data
active) that situation tends to be rare and not apply to most memory.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
