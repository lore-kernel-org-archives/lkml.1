Return-Path: <linux-kernel-owner+w=401wt.eu-S1754959AbYIIW2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959AbYIIW2S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 18:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753000AbYIIW2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 18:28:09 -0400
Received: from gw.goop.org ([64.81.55.164]:37242 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691AbYIIW2I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 18:28:08 -0400
Message-ID: <48C6F875.4060409@goop.org>
Date: Tue, 09 Sep 2008 15:28:05 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Alex Nixon <alex.nixon@citrix.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Xen: Fix pte unpin BUG when !CONFIG_SMP
References: <> <1220959508-13806-1-git-send-email-alex.nixon@citrix.com> <48C6BB00.9040607@goop.org> <48C6CCD7.8030800@citrix.com> <48C6DE6E.1070804@goop.org> <48C6F80E.8010509@citrix.com>
In-Reply-To: <48C6F80E.8010509@citrix.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Nixon wrote:
> Hmm ok.  I'll search further for a solution which fixes things more
> officially (and deals with the CONFIG_SMP && (NR_CPUS <
> CONFIG_SPLIT_PTLOCK_CPUS) case, which I just realized is also broken,
> and isn't fixed by this patch).
>
> In the meantime, at least UP is now usable.

I've got a patch here which fixes it.  Will post shortly.

    J
