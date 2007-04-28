Return-Path: <linux-kernel-owner+w=401wt.eu-S1161783AbXD1JWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161783AbXD1JWy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 05:22:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753549AbXD1JWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 05:22:54 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:18551 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395AbXD1JWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 05:22:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=RKc42+ycXnshxUj/Cl7fH0/eHNPw6zhJ9d7/X1MWH2EPU+pxKSPyupYzgX1XsPWs5WFbp4cCu89AwfPomaz3BIQ7JS6nSXa1sRKWyVRqXkmq3A0yjRh1Ae2KmhAS/sWIndiXeDxAdpZMiZ06XxDPvbvz1RGd5uE1X91BLkHsZxk=
Message-ID: <84144f020704280222s42ff99ddg3eea3cb353c8882e@mail.gmail.com>
Date: Sat, 28 Apr 2007 12:22:51 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Oliver Neukum" <oliver@neukum.org>
Subject: Re: Back to the future.
Cc: "Nigel Cunningham" <nigel@nigel.suspend2.net>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200704272107.28565.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1177567481.5025.211.camel@nigel.suspend2.net>
	 <200704271150.55701.oliver@neukum.org>
	 <Pine.LNX.4.64.0704271303260.925@sbz-30.cs.Helsinki.FI>
	 <200704272107.28565.oliver@neukum.org>
X-Google-Sender-Auth: ac35190e7e02bb42
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oliver,

Am Freitag, 27. April 2007 12:12 schrieb Pekka J Enberg:
> > The problem with writing in the kernel is obvious: we need to add new code
> > to the kernel for compression, encryption, and userspace interaction
> > (graphical progress bar) that are important for user experience.

On 4/27/07, Oliver Neukum <oliver@neukum.org> wrote:
> The kernel can already do compression and encryption.

Yes, if we all could agree on _which_ compression and encryption
algorithm(s) we want to use. It goes beyond that too, where do you
want to save the image? In the swap device or a regular file? And
don't forget about debuggability either. It's faster to do a
snapshot/resume without shutdown/restart in the middle or just do a
snapshot, and examine its contents.
