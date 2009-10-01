Return-Path: <linux-kernel-owner+w=401wt.eu-S1751118AbZJAE1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751118AbZJAE1t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 00:27:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750821AbZJAE1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 00:27:49 -0400
Received: from mail-yw0-f192.google.com ([209.85.211.192]:48736 "EHLO
	mail-yw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbZJAE1s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 00:27:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=edKrhEOe+ACG1Ym5ZhJdKnd7kpycjm5jHqyKjUObe1+3gPMQ1KnLdwJMxbre8/eGrr
         rdziLiMuq/oUrMmQ7yVCFytaKziNBYdkDWzH+u9ULnULHfAXlXrbZuK4uGOzhhk56Rvv
         w+seIEL20k2cCg/URZkwH/m+q9Dmhoskj9kzY=
MIME-Version: 1.0
In-Reply-To: <1253231273-16423-5-git-send-email-vapier@gentoo.org>
References: <1253231273-16423-1-git-send-email-vapier@gentoo.org> 
	<1253231273-16423-5-git-send-email-vapier@gentoo.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 1 Oct 2009 00:27:32 -0400
Message-ID: <8bd0f97a0909302127v21e1fbck28afac9e0e579063@mail.gmail.com>
Subject: Re: [Uclinux-dist-devel] [PATCH 5/5] Blackfin SPI: clean up error 
	handling in client setup
To: David Brownell <dbrownell@users.sourceforge.net>
Cc: spi-devel-general@lists.sourceforge.net,
       uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 17, 2009 at 19:47, Mike Frysinger <vapier@gentoo.org> wrote:
> From: Yi Li <yi.li@analog.com>
>
> Make sure we don't leak peripheral/gpio resources when an error occurs
> during setup, and make sure we don't call kfree() twice on the same
> object.  Also add/fix some error messages in the process.

not sure if you've picked any of these changes up David, but if you
havent, please skip this last patch.  it needs some updating as it
introduces at least one NULL ptr deref in the error path.
-mike
