Return-Path: <linux-kernel-owner+w=401wt.eu-S1757808AbZD2PXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757808AbZD2PXU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 11:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755260AbZD2PXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 11:23:12 -0400
Received: from one.firstfloor.org ([213.235.205.2]:44737 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754932AbZD2PXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 11:23:11 -0400
To: linux-kernel@vger.kernel.org
Subject: Re: splice() on two pipes
From: Andi Kleen <andi@firstfloor.org>
References: <20090429103308.GA23684@squirrel.roonstrasse.net>
Date: Wed, 29 Apr 2009 17:23:05 +0200
In-Reply-To: <20090429103308.GA23684@squirrel.roonstrasse.net> (Max Kellermann's message of "Wed, 29 Apr 2009 12:33:08 +0200")
Message-ID: <87my9zpjqe.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Max Kellermann <max@duempel.org> writes:

I don't think splice is about handling all possible cases,
but just cases where the kernel can do better than user space.
I don't think that's the case here.

> when I read about the splice() system call, I thought it was obvious
> that it could copy data between two pipes. 

It would be more efficient if you used fd passing to pass the fd
around to the other process and let it read directly.

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only.
