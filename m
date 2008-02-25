Return-Path: <linux-kernel-owner+w=401wt.eu-S1754590AbYBYJ6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590AbYBYJ6l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 04:58:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752775AbYBYJ6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 04:58:32 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:3553 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519AbYBYJ6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 04:58:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=nmwoS2V5TsTC+ELIJwEFr1ttR9DjXHcRjuijbZVt0yruWhmQkTwliUtCAlKNN8Df3/cqNBpwDonCglaYAlOdv3ErbHh4/1ZzK6a8iEViowXZp5Td7tOSVqyIFOrLMq1KDVzWQ9o7wwFIBGHMGrGiHQ9KnyN7POF7LMrHulbxC2I=
Date: Mon, 25 Feb 2008 12:58:00 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: vmlinux.lds cleanup
Message-ID: <20080225095800.GB6744@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sam,

you know I've just take a look on different architectures and I suddenly
realized that I even can't test my changes I'm bringnin in. For example -
xtensa arch, most of lds numeric constants could (and should) be changed
to PAGE_SIZE and THREAD_SIZE but this requires to include additional
heades in lds script and I'm not even sure if it link without errors...
(actually, i'm absolutely sure there would be errors ;)

I'm not sure, but maybe it would be more convenient to ask mainteiners
fix their scripts? At least their have access to an appropriate hardware
to test.

		- Cyrill -
