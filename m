Return-Path: <linux-kernel-owner+w=401wt.eu-S1751555AbXDASKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751555AbXDASKc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 14:10:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751570AbXDASKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 14:10:31 -0400
Received: from smtp-out.google.com ([216.239.45.13]:48591 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbXDASKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 14:10:30 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=SSezp9TXVXXFSC4Szt8ONno6TVqZ0Ps+fiDwvvoZUCxp89nqI5+dGslItO8GFax4y
	F0CkYKzASJdUTyIRflbpw==
Message-ID: <b040c32a0704011110n639d6ea4h447646b6da92974e@mail.gmail.com>
Date: Sun, 1 Apr 2007 11:10:26 -0700
From: "Ken Chen" <kenchen@google.com>
To: "Tomas M" <tomas@slax.org>
Subject: Re: [patch] remove artificial software max_loop limit
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <460FE478.9070901@slax.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b040c32a0703300053u110063b0u80ee0e7b9dd158c2@mail.gmail.com>
	 <b040c32a0703300148w479cf4cdw667cf464edf7c725@mail.gmail.com>
	 <Pine.LNX.4.61.0703301105190.31834@yvahk01.tjqt.qr>
	 <b040c32a0703300225r3f8b1daah2f95e8af26c0d867@mail.gmail.com>
	 <20070330141524.5f6cff29.akpm@linux-foundation.org>
	 <460FE380.2050608@slax.org> <460FE478.9070901@slax.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/1/07, Tomas M <tomas@slax.org> wrote:
> I believe that IF you _really_ need to preserve the max_loop module
> parameter, then the parameter should _not_ be ignored, rather it should
> have the same function like before - to limit the loop driver so if you
> use max_loop=10 for example, it should not allow loop.c to create more
> than 10 loops.

Blame on the dual meaning of max_loop that it uses currently: to
initialize a set of loop devices and as a side effect, it also sets
the upper limit.  People are complaining about the former constrain,
isn't it?  Does anyone uses the 2nd meaning of upper limit?

- Ken
