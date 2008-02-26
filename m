Return-Path: <linux-kernel-owner+w=401wt.eu-S932587AbYBZW23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932587AbYBZW23 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 17:28:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765419AbYBZWX4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 17:23:56 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:24008 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764946AbYBZWXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 17:23:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=SjKqnqbNv6Lz4+kSS5hTSVqKuRhXgNhzpG+oQysdjgQfwB7tqBciDD6uUpqVzyXo6aRALrg0bWXqrLikn86hw4jRSXJY25N1Bsn7OZ+qISmFQWRNJ6YEI6s6EXJfl6yLnF7SFwqDOtuPNW7oGLFYenbXEU7hjSBIO0kDvVfU6/4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH] ide-cd: fix some codestyle and most of the checkpatch.pl issues
Date: Tue, 26 Feb 2008 23:37:29 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>,
       Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
References: <1204012194-4208-1-git-send-email-petkovbb@gmail.com> <1204012194-4208-3-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1204012194-4208-3-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802262337.29873.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tuesday 26 February 2008, Borislav Petkov wrote:
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
> ---
>  drivers/ide/ide-cd.c |  634 +++++++++++++++++++++++++------------------------
>  1 files changed, 323 insertions(+), 311 deletions(-)

With 300 lines changed this is not trivial to review/apply anymore
(yeah, I sound like a broken record ;-) and since I've already applied
Paolo's patch from two days ago this one heavily rejects...

Moreover md5sum is different before/after the patch - I tried really hard
to figure out why (by reverting some changes) but finally I gave up.

Please:
- resync
- factor out changes which affect resulting binary
- resubmit

Thanks,
Bart
