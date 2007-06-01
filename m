Return-Path: <linux-kernel-owner+w=401wt.eu-S1760230AbXFAKfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760230AbXFAKfh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 06:35:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758296AbXFAKfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 06:35:30 -0400
Received: from mx2.suse.de ([195.135.220.15]:56621 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757191AbXFAKfa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 06:35:30 -0400
To: "George Krajcsovits" <george.krajcsovits@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Callchain contains impossible call
References: <42c83d030706010019u13219322o7cec0c7aa08dd01f@mail.gmail.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 01 Jun 2007 13:32:07 +0200
In-Reply-To: <42c83d030706010019u13219322o7cec0c7aa08dd01f@mail.gmail.com>
Message-ID: <p73wsync3m0.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"George Krajcsovits" <george.krajcsovits@gmail.com> writes:

> this is probably RTFM (where is this manual?), but how did I get a
> callchain on a uniprocessor
> system where there are two functions that cannot be a part of it,
> because they don't call anything ? (kfree_skbmem and __kmalloc). Also
> at the end one function call is there twice.

Linux stack traces are not exact by default.

-Andi
