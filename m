Return-Path: <linux-kernel-owner+w=401wt.eu-S1764697AbYHHWLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764697AbYHHWLj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 18:11:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762130AbYHHVzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 17:55:36 -0400
Received: from one.firstfloor.org ([213.235.205.2]:33747 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762367AbYHHVze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 17:55:34 -0400
Date: Fri, 8 Aug 2008 23:56:25 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Chris Mason <chris.mason@oracle.com>
Cc: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <peterz@infradead.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: Btrfs v0.16 released
Message-ID: <20080808215625.GC9038@one.firstfloor.org>
References: <1217962876.15342.33.camel@think.oraclecorp.com> <1218100464.8625.9.camel@twins> <1218105597.15342.189.camel@think.oraclecorp.com> <877ias66v4.fsf@basil.nowhere.org> <1218221293.15342.263.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1218221293.15342.263.camel@think.oraclecorp.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So, the mirroring turns a single large write into two large writes.
> Definitely not free, but always a fixed cost.

Thanks for the explanation and the numbers. I see that's the advantage of 
copy-on-write that you can actually always cluster the metadata together and 
get always batched IO this way and then afford to do more of it. 

Still wondering what that will do to read seekiness.

-Andi
