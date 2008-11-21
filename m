Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753235AbYKUGM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235AbYKUGM6 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Fri, 21 Nov 2008 01:12:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751570AbYKUGMp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 01:12:45 -0500
Received: from rv-out-0506.google.com ([209.85.198.236]:8977 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205AbYKUGMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 01:12:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=cc:message-id:from:to:in-reply-to:content-type
         :content-transfer-encoding:mime-version:subject:date:references
         :x-mailer;
        b=uFNGbcKX6WCtVtx5q5rVwqcQ9EuYLayMFV6SrvCd6zEqxFNUKI8jrfpNTpEneKA0gt
         D4QgiIpvcKfwAhGbmh4h0QJUs0KZVZucR9+cEotkK1Ba/CNOMDOcEeTir8QpoVc11SFd
         mSs9sDRFewOVYaxYizWtJTXSYerBGLkPOiYS0=
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <DE425C06-700A-4042-B0AB-1CDE2134C4DF@gmail.com>
From: Richard Holden <aciddeath@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
In-Reply-To: <20081121103409.fed9a837.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: Re: [PATCH] Remove unused variables from the cirrusfb driver
Date: Thu, 20 Nov 2008 23:12:42 -0700
References: <1227204203-32112-1-git-send-email-aciddeath@gmail.com> <1227204203-32112-2-git-send-email-aciddeath@gmail.com> <20081121103409.fed9a837.sfr@canb.auug.org.au>
X-Mailer: Apple Mail (2.929.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 20, 2008, at 4:34 PM, Stephen Rothwell wrote:

> Hi Richard,
>
> On Thu, 20 Nov 2008 11:03:22 -0700 "Richard A. Holden III" <aciddeath@gmail.com 
> > wrote:
>>
>> Remove i and s vars from cirrusfb_setup as they are not used
>> anywhere in that function. This fixes 2 unused vars build warnings.
>
> Thanks for the patch, but this is already fixed in mainline (commit
> ee11940f8e7a2f064af22d52180cb5f9643eef61 "cirrusfb: remove unused
> variables").
>
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/

Am I right in assuming you pulled mainline before this commit for  
next-20081120? I don't see the changelog in next and I'm getting the  
build warnings still, but I can recheck this in the next version of  
next.

-Richard Holden
