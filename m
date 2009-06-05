Return-Path: <linux-kernel-owner+w=401wt.eu-S1752462AbZFELGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462AbZFELGU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 07:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751682AbZFELGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 07:06:13 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34485 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419AbZFELGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 07:06:12 -0400
To: Igor Zhbanov <izh1979@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Can kmalloc( ) with __GFP_WAIT flag fail?
From: Andi Kleen <andi@firstfloor.org>
References: <f44001920906050359h5edc6782n69aa91472aae418f@mail.gmail.com>
Date: Fri, 05 Jun 2009 13:06:10 +0200
In-Reply-To: <f44001920906050359h5edc6782n69aa91472aae418f@mail.gmail.com> (Igor Zhbanov's message of "Fri, 5 Jun 2009 14:59:31 +0400")
Message-ID: <871vpz6iu5.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Igor Zhbanov <izh1979@gmail.com> writes:

> Hello!
>
> Can kmalloc( ) fail when invoked with __GFP_WAIT flag (which is
> implied by GFP_KERNEL)?

Yes it can fail.

> And for what reason it may fail?

When the kernel is out of memory.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
