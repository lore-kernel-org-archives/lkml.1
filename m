Return-Path: <linux-kernel-owner+w=401wt.eu-S933558AbYAaSOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933558AbYAaSOS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 13:14:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759315AbYAaSOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 13:14:05 -0500
Received: from cantor.suse.de ([195.135.220.2]:54529 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753336AbYAaSOE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 13:14:04 -0500
To: Lars Noschinski <lklml@ml.noschinski.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: How does ext2 implement sparse files?
From: Andi Kleen <andi@firstfloor.org>
References: <20080131152823.GA29422@lars.home.noschinski.de>
Date: Thu, 31 Jan 2008 19:14:01 +0100
In-Reply-To: <20080131152823.GA29422@lars.home.noschinski.de> (Lars Noschinski's message of "Thu\, 31 Jan 2008 16\:28\:23 +0100")
Message-ID: <p73myql50d2.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lars Noschinski <lklml@ml.noschinski.de> writes:

> For an university project, we had to write a toy filesystem (ext2-like),
> for which I would like to implement sparse file support. For this, I
> digged through the ext2 source code; but I could not find the point,
> where ext2 detects holes.
>
> As far as I can see from fs/buffer.c, an hole is a buffer_head which is
> not mapped, but uptodate. But I cannot find a relevant source line,
> where ext2 makes usage of this information.

It does not explicitely detect holes; holey data is just never written
so no space for it is allocated.

-Andi
