Return-Path: <linux-kernel-owner+w=401wt.eu-S1753759AbYFUOFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759AbYFUOFc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 10:05:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751147AbYFUOFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 10:05:21 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:36642 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751034AbYFUOFT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 10:05:19 -0400
Date: Sat, 21 Jun 2008 18:07:41 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hugh@veritas.com>, Jonathan Corbet <corbet@lwn.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] get_user_pages: minor code tweaks
Message-ID: <20080621140741.GA13422@tv-sign.ru>
References: <20080621134125.GA10854@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080621134125.GA10854@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21, Oleg Nesterov wrote:
>
> No functional changes.

Heh.

> 2. Move "foll_flags |= FOLL_WRITE;" from the inner loop up.

Please ignore this patch, it is wrong. FOLL_WRITE can be cleared after
handle_mm_fault().

Oleg.

