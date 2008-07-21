Return-Path: <linux-kernel-owner+w=401wt.eu-S1753516AbYGUNlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516AbYGUNlU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 09:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751599AbYGUNlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 09:41:11 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:59854 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394AbYGUNlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 09:41:10 -0400
Date: Mon, 21 Jul 2008 15:41:08 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Adrian Bunk <bunk@kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: asm-x86/processor-flags.h, CONFIG_* leaks
Message-ID: <20080721134108.GA28729@aepfle.de>
References: <20080721124656.GA28618@aepfle.de> <20080721130635.GA19123@localhost.localdomain> <20080721130843.GA28640@aepfle.de> <19f34abd0807210631k3e76e565t9167ab4f8c21f31e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <19f34abd0807210631k3e76e565t9167ab4f8c21f31e@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, Vegard Nossum wrote:

> all this ideally be fixed in some way?

Yes, they should be moved inside __KERNEL__, or the header shouldnt be
exported at all.
