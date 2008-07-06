Return-Path: <linux-kernel-owner+w=401wt.eu-S1759524AbYGFVZH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759524AbYGFVZH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 17:25:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757985AbYGFVY4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 17:24:56 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:29196 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756916AbYGFVY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 17:24:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=H9ytGno3dFxN7nBh7qqY7Gz2DNX7T1gRVyPmXh1IfpQDpWeTSftm7gIz7YJUMurO8w
         lLRj7NU5I8INPTM6Y9NpBDqCtCoKlmNPaa5taXoBwx7sYhrotQcMmC6wZgSgBWaW3DGm
         hhaZVhuoZKHNwXXZoeYMJrLrzLgyIhQpWwzAY=
Message-ID: <9871ee5f0807061424o535c6d7eg3071da6e31e0b58e@mail.gmail.com>
Date: Sun, 6 Jul 2008 17:24:54 -0400
From: "Timothy Normand Miller" <theosib@gmail.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: HELP: Getting unexpected fakeraid behavior. Fix?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080706131937.13065312@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9871ee5f0807061307ncc55104y477c57be3e91b75f@mail.gmail.com>
	 <20080706131937.13065312@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 6, 2008 at 4:19 PM, Arjan van de Ven <arjan@infradead.org> wrote:

> if your application is single threaded this isn't totally unexpected as
> a result...

Ok, I've rewritten the program to use multiple threads.  There is a
bzcat process that's sequentially reading a large file, and then
there's another process with four threads that is reading lots of
small files with a lot of random access.  All threads are constrained
by the disk (CPU load is low).

I'm still seeing absolutely NO reads from the second disk.

Any ideas?

Thanks.


-- 
Timothy Normand Miller
http://www.cse.ohio-state.edu/~millerti
Open Graphics Project
