Return-Path: <linux-kernel-owner+w=401wt.eu-S1753989AbYCLV7B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989AbYCLV7B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 17:59:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752319AbYCLV6x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 17:58:53 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55302 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752137AbYCLV6x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 17:58:53 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] signals: fold sig_ignored() into handle_stop_signal()
In-Reply-To: Oleg Nesterov's message of  Wednesday, 12 March 2008 15:33:11 +0300 <20080312123311.GA13478@tv-sign.ru>
References: <20080312123311.GA13478@tv-sign.ru>
Emacs: more boundary conditions than the Middle East.
Message-Id: <20080312215848.606F726F992@magilla.localdomain>
Date: Wed, 12 Mar 2008 14:58:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This one looks fine to me.  I would like the comment above the function to
be updated to describe its new purpose, and to document its return value's
meaning.  

Also, I'm not sure if there is a kernel code formatting convention that
particularly excludes an empty block ({}, equiv to ;) containing just
comments.  But I don't recall seeing that style used in the kernel.
(I don't mind it personally for this case given what the obvious
alternatives would look like.)


Thanks,
Roland

