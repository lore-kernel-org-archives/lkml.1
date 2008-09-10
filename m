Return-Path: <linux-kernel-owner+w=401wt.eu-S1755578AbYIJVUL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578AbYIJVUL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 17:20:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752765AbYIJVT7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 17:19:59 -0400
Received: from qb-out-0506.google.com ([72.14.204.225]:28542 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbYIJVT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 17:19:58 -0400
Message-ID: <f488382f0809101419y65b35547t572a0f7bb5316952@mail.gmail.com>
Date: Wed, 10 Sep 2008 14:19:56 -0700
From: "Steven Noonan" <steven@uplinklabs.net>
To: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>
Subject: Re: [PATCH] drivers/ide/ide-probe.c: uninitialized variable 'rc'
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
In-Reply-To: <200809102309.34159.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1220994461-15962-1-git-send-email-steven@uplinklabs.net>
	 <200809102309.34159.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2008 at 2:09 PM, Bartlomiej Zolnierkiewicz
<bzolnier@gmail.com> wrote:
>
> I recall seeing identical patch before:
>
>        http://article.gmane.org/gmane.linux.ide/33107
>
> Does the existing code really results in gcc warning?
>
>

Yes, because GCC thinks it's possible that the for loop has zero
iterations (and hence, 'rc' is never touched).

- Steven
