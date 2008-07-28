Return-Path: <linux-kernel-owner+w=401wt.eu-S1759564AbYG1Rov@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759564AbYG1Rov (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 13:44:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752446AbYG1Rok
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 13:44:40 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:54273 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751563AbYG1Rok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 13:44:40 -0400
Date: Mon, 28 Jul 2008 12:44:37 -0500
From: Jack Steiner <steiner@sgi.com>
Cc: Nick Piggin <npiggin@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: GRU driver feedback
Message-ID: <20080728174437.GA29795@sgi.com>
References: <20080723141229.GB13247@wotan.suse.de> <20080728173605.GB28480@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080728173605.GB28480@sgi.com>
User-Agent: Mutt/1.4.2.1i
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Whoops:

>
> - In gru_fault, I don't think you've validated the size of the vma, and it
>   definitely seems like you haven't taken offset into the vma into account
>   either. remap_pfn_range etc should probably validate the former because I'm
>   sure this isn't the only driver that might get it wrong. The latter can't
>   really be detected though. Please fix or make it more obviously correct (eg
>   a comment).

ZZZ
s/ZZZ/fixed/



--- jack
