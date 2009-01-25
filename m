Return-Path: <linux-kernel-owner+w=401wt.eu-S1753260AbZAYVjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260AbZAYVjp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 16:39:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752514AbZAYVjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 16:39:24 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:44600 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbZAYVjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 16:39:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=VxEa6UgAsLC7mNcgXVw/6MNqnA3sScnuJObIDm2XqYXq/ag7e4ZStVL//i/eWZuEHp
         oSF82yhoBk6mmR29NRn3Jcz5LWE18CyeTuFD4huFUTCcf0jQk4dh51pq9eX6cf1PXyD+
         S73y4URy7rix5Tc+m0fkX99Uk+xYBrYNNyM/4=
Message-ID: <497CDC06.3030900@gmail.com>
Date: Sun, 25 Jan 2009 22:39:18 +0100
From: Andrea Righi <righi.andrea@gmail.com>
Reply-To: righi.andrea@gmail.com
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: linux-mm@kvack.org, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mmotm] mm: unify some pmd_*() functions
References: <1232919337-21434-1-git-send-email-righi.andrea@gmail.com>
In-Reply-To: <1232919337-21434-1-git-send-email-righi.andrea@gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2009-01-25 22:35, Andrea Righi wrote:
> Unify all the identical implementations of pmd_free(), __pmd_free_tlb(),
> pmd_alloc_one(), pmd_addr_end() in include/asm-generic/pgtable-nopmd.h
> 

BTW, I only tested this on x86 and x86_64. This needs more testing because it
touches also a lot of other architectures.

-Andrea
