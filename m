Return-Path: <linux-kernel-owner+w=401wt.eu-S1756893AbYBINUL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756893AbYBINUL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 08:20:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754593AbYBINT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 08:19:58 -0500
Received: from web52008.mail.re2.yahoo.com ([206.190.48.57]:42226 "HELO
	web52008.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754589AbYBINT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 08:19:57 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=5FkgYHciWbPIIuVKeWoOIfuPupQE42JUBy/lRN4pzL8qA5ery5asq2QfR6h7oa24MuCEgbIkn8FRfdoLlQ5zNVv/IZ8kGicdP2W+ZHzbl0bCyWTQ1MfTC70cNlRdK2yZhopMvs17XyGI/UJzbAF8eC4i3ZaadxZ/wuzVd6CZGzg=;
X-YMail-OSG: _Kxq3HgVM1lUqUtz2h8oTALMNNK4cE571ckqlRzu64fG0ZFvRjoQB9jxfLHUKKeXbuXein8nRiecJJY6qrkzxRFlAKJJfMKDNK.PQ1FCIF1lH3OTHDfNopScr6KS_2Q9uSxUZqWMvvlnU6Q-
Date: Sat, 9 Feb 2008 05:19:55 -0800 (PST)
From: Doug Kehn <rdkehn@yahoo.com>
Subject: Re: Soft lockup 2.6.23.14-uc0
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: linux-kernel@vger.kernel.org, uClinux <uclinux-dev@uclinux.org>
In-Reply-To: <18344.31682.388710.182172@harpo.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <65230.82874.qm@web52008.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mikael/All,

--- Mikael Pettersson wrote:


> Anyway, I can think of two things:
> 
> 1. There was some very recent patches by Peter
> Zijlstra
>    addressing hrtimer breakage on arm and some other
>    archs in 2.6.24-git. If uclinux has backported
> some
>    of that stuff then it might explain this issue.
> 
> 2. There is a new native Linux driver for ixp4xx
>    ethernet. Patches for the 2.6.23.14 kernel can
>    be found in the nslu2-linux group's subversion
>    repository. (You'll need new firmware files
> though.)
>    Replacing Intel's IXP400 drivers with this driver
>    should at least tell you if the lockups are
>    related to your use of the Intel drivers.
> 

I'm working through Mikael's suggestions.

A new piece of information is that the soft lockups
only occur when the IXP420 is transmitting.  I started
using unidirectional streams; I don't observe soft
lockups when receiving.  I only observe them when
transmitting.

Thanks,
...doug



      ____________________________________________________________________________________
Never miss a thing.  Make Yahoo your home page. 
http://www.yahoo.com/r/hs
