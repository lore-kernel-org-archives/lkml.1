Return-Path: <linux-kernel-owner+w=401wt.eu-S1754963AbYJLUAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754963AbYJLUAY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 16:00:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753783AbYJLUAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 16:00:06 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34911 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753712AbYJLUAF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 16:00:05 -0400
Date: Sun, 12 Oct 2008 22:00:04 +0200
From: Karel Zak <kzak@redhat.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [kerneloops] regression in 2.6.27 wrt "lock_page" and the
	"hwclock" program
Message-ID: <20081012200004.GI10429@nb.net.home>
References: <20081004174433.14a5e093@infradead.org> <20081004215225.2444d54b.akpm@linux-foundation.org> <20081005081145.30ba921b@infradead.org> <20081005102742.de8353b4.akpm@linux-foundation.org> <20081005103826.6771540a@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081005103826.6771540a@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 05, 2008 at 10:38:26AM -0700, Arjan van de Ven wrote:
> I get the impression from the code that it really wants a "don't
> schedule me out" rather than "this is a lock".

 Yes, I think so.

> it can do better.

 Any suggestion how to nicely implement "don't schedule me out"?

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
