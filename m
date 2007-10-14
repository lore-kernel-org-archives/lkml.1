Return-Path: <linux-kernel-owner+w=401wt.eu-S1757335AbXJNKlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757335AbXJNKlU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 06:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755534AbXJNKlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 06:41:07 -0400
Received: from rv-out-0910.google.com ([209.85.198.191]:59163 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755540AbXJNKlG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 06:41:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=akjt7H0XSKIPc9O2581ze1cF/amZ1mejuZnumGsaVXEfQIxPM0kMAp6FV3gzGek0ZnMAlRTrWIClMk21FIBUUAZ/PFmD/Hy7AEB553EUdEp/cAILjeTNWBUvz5PCb9OjkGycl7jMd1SC+ADZ9tMhzx2Re3fwfiyKkNfCtO6Q1X0=
Message-ID: <21d7e9970710140341i25afc47cwdd9e441a0d2e2d0f@mail.gmail.com>
Date: Sun, 14 Oct 2007 20:41:05 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "=?ISO-8859-1?Q?Thomas_B=E4chler?=" <thomas@archlinux.org>
Subject: Re: 2.6.23(.1) Regression? i915 oopses and panics
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <fesqkn$lml$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <fesqkn$lml$1@ger.gmane.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/07, Thomas Bächler <thomas@archlinux.org> wrote:
> I first discovered this problem when updating to 2.6.23 final on x86_64.
> When I launched google earth, the kernel paniced. When I tried to
> reproduce, it oopsed instead of panicing.
>
> dri/drm seems to work generally, as I am running beryl without trouble,
> so far I could only reproduce the problem with google earth.
>
> I have been using 2.6.23-rc6 for a while before, but I cannot tell if
> the problem already occured there. I am sure though that it wasn't there
> on 2.6.22(.Y). If anyone can tell me which commit might have caused
> this, I can revert it and test though.

lets start with:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=e4a7b1d1d90d202a030688ab5b177c3c0f15ee3e

and work from there..

Dave.
