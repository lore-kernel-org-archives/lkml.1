Return-Path: <linux-kernel-owner+w=401wt.eu-S933050Ab0AGDsx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933050Ab0AGDsx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 22:48:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932386Ab0AGDsv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 22:48:51 -0500
Received: from mail-iw0-f194.google.com ([209.85.223.194]:61954 "EHLO
	mail-iw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932363Ab0AGDsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 22:48:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=n7XUBymtB5iDbWPKAHZBxJmu3ha3u+leDXNokATXq6x1Liw/fMP9cf+mffdDL6WTgI
         XVB0QZqAY43ylFFlauuMUmyRGYX0u+s3fwRx9+fETn2/LLE+dF+SYoi/fc6LcnS0m7Wt
         1+Ho9cStPNYVcFAw/iTccnMCyLDkJ4e3fH7Uk=
MIME-Version: 1.0
In-Reply-To: <1262136235.8733.33.camel@ICE-BOX>
References: <1262136235.8733.33.camel@ICE-BOX>
Date: Thu, 7 Jan 2010 13:48:49 +1000
Message-ID: <21d7e9971001061948m466e0abdwb03ceef2cb947687@mail.gmail.com>
Subject: Re: [PATCH] drm/radeon/radeon_cp.c: check for invalid radeon family
From: Dave Airlie <airlied@gmail.com>
To: Darren Jenkins <darrenrjenkins@gmail.com>
Cc: David Airlie <airlied@linux.ie>,
       dri-devel mailing list <dri-devel@lists.sourceforge.net>,
       Kernel Janitors <kernel-janitors@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 30, 2009 at 11:23 AM, Darren Jenkins
<darrenrjenkins@gmail.com> wrote:
> If there is an invalid radeon family the fw_name is NULL and causes an
> NULL pointer dereference.
> This just adds a check for something unexpected.
>

Same as for last one, unless a developer explicity writes code wrong,
this cannot
happen, and I'd prefer a developer would see an oops.

Dave.
