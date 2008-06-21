Return-Path: <linux-kernel-owner+w=401wt.eu-S1753149AbYFUHaC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149AbYFUHaC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 03:30:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751032AbYFUH3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 03:29:52 -0400
Received: from smtp-out.google.com ([216.239.33.17]:43847 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbYFUH3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 03:29:51 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=ot26js8VhWWUTDNZGPQJ2cYrYL/ID79oFg8rujM5pAfP3wkHUshn0ZBI4rkFoUm00
	VXL36HkITkHKqYmge87yA==
Message-ID: <6599ad830806210029x2a020e1ava6b646be9913fcdf@mail.gmail.com>
Date: Sat, 21 Jun 2008 00:29:41 -0700
From: "Paul Menage" <menage@google.com>
To: "Balbir Singh" <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH] Priority heap infrastructure enhancements
Cc: akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1213796886-24863-1-git-send-email-balbir@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1213796886-24863-1-git-send-email-balbir@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2008 at 6:48 AM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>
> Some of the common code has been factored into heap_adjust() a.k.a heapify
> in data structures terminology.
>
> I am sending out this  patch indepedent of the memory controller changes as
> they deserve to be reviewed independently.
>
> One limitation of the current heap_insert() routine is that it does not
> insert an element which is greater than the root, when the heap slots
> are fully used. I'll work on and review that interface and find a suitable
> way to address that issue

How else would you want it to behave? If you have a fixed size heap
and it's full, then you have to drop the largest value. (Well, you
could in theory drop the smallest value, but there's no quick way to
find that.)

>
> Comments, Flames? Please do review closely!
>
> Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>

Looks fine.

Reviewed-by: Paul Menage <menage@google.com>

Paul
