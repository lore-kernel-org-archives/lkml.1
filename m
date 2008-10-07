Return-Path: <linux-kernel-owner+w=401wt.eu-S1754585AbYJGLUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585AbYJGLUg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 07:20:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752832AbYJGLU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 07:20:29 -0400
Received: from one.firstfloor.org ([213.235.205.2]:47075 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641AbYJGLU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 07:20:28 -0400
Date: Tue, 7 Oct 2008 13:26:31 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH, RFC, v2] shmat: introduce flag SHM_MAP_HINT
Message-ID: <20081007112631.GH20740@one.firstfloor.org>
References: <20081006192923.GJ3180@one.firstfloor.org> <1223362670-5187-1-git-send-email-kirill@shutemov.name> <20081007082030.GD20740@one.firstfloor.org> <20081007100854.GA5039@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081007100854.GA5039@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I want say that we shouldn't do this check if shmaddr is a search hint.
> I'm not sure that check is unneeded if shmadd is the exact address.

mmap should fail in this case because it does the same check for 
MAP_FIXED. Obviously it cannot succeed when there is already something
else there.

-Andi

-- 
ak@linux.intel.com
