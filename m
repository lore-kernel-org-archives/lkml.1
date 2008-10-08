Return-Path: <linux-kernel-owner+w=401wt.eu-S1754846AbYJHIhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846AbYJHIhu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 04:37:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751307AbYJHIhm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 04:37:42 -0400
Received: from one.firstfloor.org ([213.235.205.2]:50776 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbYJHIhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 04:37:41 -0400
Date: Wed, 8 Oct 2008 10:43:50 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andi Kleen <andi@firstfloor.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "Kirill A. Shutemov" <kirill@shutemov.name>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Ingo Molnar <mingo@redhat.com>, Arjan van de Ven <arjan@infradead.org>,
       Hugh Dickins <hugh@veritas.com>, Ulrich Drepper <drepper@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH, v3] shmat: introduce flag SHM_MAP_NOT_FIXED
Message-ID: <20081008084350.GI7971@one.firstfloor.org>
References: <1223396117-8118-1-git-send-email-kirill@shutemov.name> <2f11576a0810070931k79eb72dfr838a96650563b93a@mail.gmail.com> <20081007211038.GQ20740@one.firstfloor.org> <20081008000518.13f48462@lxorguk.ukuu.org.uk> <20081007232059.GU20740@one.firstfloor.org> <20081008004030.7a0e9915@lxorguk.ukuu.org.uk> <20081007235737.GD7971@one.firstfloor.org> <20081008093424.4e88a3c2@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081008093424.4e88a3c2@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2008 at 09:34:24AM +0100, Alan Cox wrote:
> Oh and as a PS you can also (for the hint case) do this:
> 
> 	shmat giving an address
> 	if error
> 		shmat giving no address
> 
> from user space.

No you can't here because shmat() starts searching from the wrong
start address.

The only way would be to search manually in /proc/self/maps
and handle the races, but I hope you're not advocating that.

-Andi

-- 
ak@linux.intel.com
