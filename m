Return-Path: <linux-kernel-owner+w=401wt.eu-S1754521AbXJAIHE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521AbXJAIHE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 04:07:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751295AbXJAIGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 04:06:49 -0400
Received: from burp.tkv.asdf.org ([212.16.99.49]:48376 "EHLO burp.tkv.asdf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751102AbXJAIGs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 04:06:48 -0400
X-Greylist: delayed 501 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Oct 2007 04:06:47 EDT
To: linux-kernel@vger.kernel.org
Subject: Re: Out of memory management in embedded systems
References: <98nC1-6aM-9@gated-at.bofh.it> <98nVg-6QQ-21@gated-at.bofh.it>
	<98oeB-7gA-9@gated-at.bofh.it> <98oHC-8ai-5@gated-at.bofh.it>
	<98oRk-8mt-21@gated-at.bofh.it> <98pNu-1pp-17@gated-at.bofh.it>
	<98v6u-1h1-9@gated-at.bofh.it> <98Qu9-170-1@gated-at.bofh.it>
From: Markku Savela <msa@moth.iki.fi>
Date: Mon, 01 Oct 2007 10:58:24 +0300
In-Reply-To: <98Qu9-170-1@gated-at.bofh.it> (Abhishek Sagar's message of "Sat\, 29 Sep 2007 21\:50\:05 +0200")
Message-ID: <87odfj5krj.fsf@burp.tkv.asdf.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

How about just simple solution? Make it possible that "malloc" works
as it was originally intended: return NULL, if memory not available,
non-NULL only if allocation truly succeeded and is guaranteed..

Make kernel configuration option? (e.g. disable "over commit"
mis-feature :-)

-- 
Markku Savela
