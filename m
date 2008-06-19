Return-Path: <linux-kernel-owner+w=401wt.eu-S1757057AbYFSOqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757057AbYFSOqT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 10:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751622AbYFSOqE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 10:46:04 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:23714 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756110AbYFSOpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 10:45:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=QJluB++/33xVlsdAV6smCHv5Mxn/QbX78sm006xtTcKfoxF4hZK+ISJCHh2Tipc45n
         BTQEGZkTIYtDUpK+bie0IE22zUieqorawYNpT6AYFiuLikVYgBXdT42tBvjpWwyLHzFe
         JcbJtoo51hqDeBUXpLCzoCp6P1vZUmcWZPGHY=
Message-ID: <48f7fe350806190745u1b78ae61ue8e71619db5756f7@mail.gmail.com>
Date: Thu, 19 Jun 2008 10:45:43 -0400
From: "Ryan Hope" <rmh3093@gmail.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: [BUG] Lockless patches cause hardlock under heavy IO
Cc: linux-mm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080618142849.13e90c6d@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48f7fe350806181415l4eba61b3i1d206de03147575e@mail.gmail.com>
	 <20080618142849.13e90c6d@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well enabling these debug options is sorta useless because once it
hardlocks I cant see or do anything..

On Wed, Jun 18, 2008 at 5:28 PM, Arjan van de Ven <arjan@infradead.org> wrote:
> On Wed, 18 Jun 2008 17:15:08 -0400
> "Ryan Hope" <rmh3093@gmail.com> wrote:
>
>> I applied the following patches from 2.6-26-rc5-mm3
>
>>
>> I am on an x86_64. I dont know what other info you need...
>>
>
> if it's locking related, enabling LOCKDEP is a first good test to do.
>
> CONFIG_PROVE_LOCKING=y
> as well as the various spinlock/mutex lock debug questions
>
>
>
> --
> If you want to reach me at my work email, use arjan@linux.intel.com
> For development, discussion and tips for power savings,
> visit http://www.lesswatts.org
>
