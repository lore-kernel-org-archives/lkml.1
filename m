Return-Path: <linux-kernel-owner+w=401wt.eu-S933904AbZFLKcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933904AbZFLKcb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 06:32:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763517AbZFLKcV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 06:32:21 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42204 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757157AbZFLKcU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 06:32:20 -0400
Date: Fri, 12 Jun 2009 11:33:20 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty: fix unused warning when TCGETX is not defined
Message-ID: <20090612113320.73e6f7f1@lxorguk.ukuu.org.uk>
In-Reply-To: <1244802468-13667-1-git-send-email-vapier@gentoo.org>
References: <1244802468-13667-1-git-send-email-vapier@gentoo.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Jun 2009 06:27:48 -0400
Mike Frysinger <vapier@gentoo.org> wrote:

> If TCGETX is not defined, we end up with this warning:
> drivers/char/tty_ioctl.c: In function ‘tty_mode_ioctl’:
> drivers/char/tty_ioctl.c:950: warning: unused variable ‘ktermx’
> 
> Since the variable is only used in one case statement, push it down to
> the local case scope.

If I wasn't so nice I'd just make it and the lack of BOTHER definitions
on platforms error. Really there shouldn't be anyone without the features
defined ;)

Alan
