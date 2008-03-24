Return-Path: <linux-kernel-owner+w=401wt.eu-S1756160AbYCXXYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160AbYCXXYc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 19:24:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753461AbYCXXYW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 19:24:22 -0400
Received: from rv-out-0910.google.com ([209.85.198.190]:54644 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753435AbYCXXYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 19:24:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WB8KFUmLVCr/cB0uNHuFRrUqsscKpQ3wMxxXGuXN3mxtWf7LZNQqT2xVhPXxfTnYVP9R/vCtmhV2HfT1Vv2ME/TG5v5R67CV2nZVlKjzv9uVg9UEBoSWCS57lA1HVXJPGHvkXD6imOe0dk4QPdEkzmjUrzwdRQvI0QJCxgpsG48=
Message-ID: <b0943d9e0803241624ne83602emc1fb4727402555d3@mail.gmail.com>
Date: Mon, 24 Mar 2008 23:24:20 +0000
From: "Catalin Marinas" <catalin.marinas@gmail.com>
To: "Jan Engelhardt" <jengelh@computergmbh.de>
Subject: Re: [ANNOUNCE] Stacked GIT 0.14.2
Cc: git <git@vger.kernel.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Josef Sipek" <jsipek@fsl.cs.sunysb.edu>
In-Reply-To: <alpine.LNX.1.10.0803242113070.9368@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b0943d9e0803241259s5280cdc1o255a4412b3fa7bfc@mail.gmail.com>
	 <alpine.LNX.1.10.0803242113070.9368@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/03/2008, Jan Engelhardt <jengelh@computergmbh.de> wrote:
> On Monday 2008-03-24 20:59, Catalin Marinas wrote:
>
>  > Stacked GIT 0.14.2 release is available from http://www.procode.org/stgit/.
>  >
>  > StGIT is a Python application providing similar functionality to Quilt
>  > (i.e. pushing/popping patches to/from a stack) on top of GIT.
>
>
> I always wondered what the difference between stgit and guilt is.
>  Does anyone have a comparison up?

There was a thread last year:

http://kerneltrap.org/mailarchive/git/2007/6/14/249310

I don't follow the guilt development to be able to comment. They are
pretty similar regarding patch management but it's probably best to
try both and see which tool you like. StGIT might have a few more
features as it was around for longer (e-mail templates, patch
synchronisation between branches etc.) but guilt seems actively
developed as well.

I might be wrong here but I'm not sure whether guilt uses three-way
merging when pushing a patch or just a two-way diff apply. The
three-way merging has several advantages in dealing with conflicts.

-- 
Catalin
