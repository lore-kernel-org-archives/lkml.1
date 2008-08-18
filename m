Return-Path: <linux-kernel-owner+w=401wt.eu-S1754118AbYHRVE1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118AbYHRVE1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 17:04:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751873AbYHRVES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 17:04:18 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40662 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751684AbYHRVER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 17:04:17 -0400
Date: Mon, 18 Aug 2008 17:04:14 -0400
From: Aristeu Rozanski <aris@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       jirislaby@gmail.com
Subject: Re: [PATCH] vt: kill tty->count usage (v2)
Message-ID: <20080818210414.GB7154@redhat.com>
References: <20080808213625.GK20355@redhat.com> <20080808222635.4fe52b51@lxorguk.ukuu.org.uk> <20080812145812.GH7154@redhat.com> <20080818181902.59ac763b@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080818181902.59ac763b@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,
> > The commit e0426e6a09954d205da2d674a3d368d2715e3afd fixes a real race but
> > still isn't enough to prevent these:
> > 
> > kobject_add_internal failed for vcs7 with -EEXIST, don't try to register
> > things with the same name in the same direc.
> 
> Patch dropped due to testing failures.
> 
> Boot to run level 3, log in and type "reboot\n". Wait
> 
> Spews vt->driver_data == NULL warnings and oopses
do you mind posting the logs somewhere? I wasn't able to reproduce it here so
far.

-- 
Aristeu

