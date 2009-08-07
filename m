Return-Path: <linux-kernel-owner+w=401wt.eu-S1756307AbZHGGuP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756307AbZHGGuP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 02:50:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755512AbZHGGuO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 02:50:14 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38704 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754982AbZHGGuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 02:50:14 -0400
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make shr to divide by power of 2
From: Andi Kleen <andi@firstfloor.org>
References: <20090806180930.GA3004@localdomain.by>
Date: Fri, 07 Aug 2009 08:50:12 +0200
In-Reply-To: <20090806180930.GA3004@localdomain.by> (Sergey Senozhatsky's message of "Thu, 6 Aug 2009 21:09:30 +0300")
Message-ID: <87d478i0d7.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sergey Senozhatsky <sergey.senozhatsky@gmail.com> writes:
>
> Of course, compiler supposed to do something like
> 	add    $0x7,%eax
> 	shr    $0x3,%eax
> instead of div. Should we rely on this?

Yes. We should rely on this. 

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
