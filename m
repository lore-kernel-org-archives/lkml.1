Return-Path: <linux-kernel-owner+w=401wt.eu-S1756457AbYCQUmP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756457AbYCQUmP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 16:42:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752942AbYCQUmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 16:42:00 -0400
Received: from one.firstfloor.org ([213.235.205.2]:52663 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361AbYCQUmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 16:42:00 -0400
Date: Mon, 17 Mar 2008 21:44:27 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Adam Litke <agl@us.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org, pj@sgi.com,
       linux-mm@kvack.org, nickpiggin@yahoo.com.au
Subject: Re: [PATCH] [2/18] Add basic support for more than one hstate in hugetlbfs
Message-ID: <20080317204427.GA10846@one.firstfloor.org>
References: <20080317258.659191058@firstfloor.org> <20080317015815.D43991B41E0@basil.firstfloor.org> <1205785364.10849.74.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1205785364.10849.74.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> PowerPC will have a 64KB huge page.  Granted, you do fix this in a later
> patch, so as long as the whole series goes together this shouldn't cause
> a problem.

No the later patch only supports GB and MB. If you want KB
you have to do it yourself.

But my patch just keeps the KB support as it was before.
> 
> Since mask can always be derived from order, is there a reason we don't

If there was a reason I forgot it. Doesn't really matter much either
way.

-Andi
