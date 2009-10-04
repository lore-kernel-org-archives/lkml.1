Return-Path: <linux-kernel-owner+w=401wt.eu-S1757423AbZJDQb6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757423AbZJDQb6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 12:31:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757378AbZJDQb5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 12:31:57 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:40262 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757274AbZJDQb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 12:31:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:in-reply-to:references
         :x-mailer:mime-version:content-type:content-transfer-encoding;
        b=Wj81zi64d1RVq0Rb2EKamet+sQvrG1cRsmpvn+1iFTWt5QnAnCKXToBck/iTnUbdqt
         8LUtqPLLFYVDVByXL+2FawS8/C+5+85XcBEKuT5OLq7yuRzKPpJBbKXQ/8Aru/ysNjTl
         xRcw7meEypqii0kqZXzjM/z4DuKHV67YROxoc=
Date: Sun, 4 Oct 2009 19:31:11 +0300
From: Pekka Paalanen <pq@iki.fi>
To: Ozan =?UTF-8?Q?=C3=87a=C4=9Flayan?= <ozan@pardus.org.tr>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       jens.axboe@oracle.com, dri-devel@lists.sf.net
Subject: Re: NULL pointer dereference at cfq_exit_single_io_context
Message-ID: <20091004193111.1e8e3baf@daedalus.pq.iki.fi>
In-Reply-To: <4AC85907.7080805@pardus.org.tr>
References: <4AC85907.7080805@pardus.org.tr>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 04 Oct 2009 11:12:55 +0300
Ozan Çağlayan <ozan@pardus.org.tr> wrote:

> Hi,
> 
> The attached dmesg is obtained on a 2.6.30.8 with:
> 
> - DRM patches mainly gathered from Fedora F-11 branch,
> - The following patch from mainline which addresses kernel
> bugzilla #13401:
> 
> From: Jeff Moyer <jmoyer@redhat.com>
> Date: Fri, 11 Sep 2009 15:08:59 +0000 (+0200)
> Subject: cfq: choose a new next_req when a request is dispatched
> X-Git-Url:
> http://git.kernel.org/?p=linux%2Fkernel%2Fgit%2Ftorvalds%2Flinux-2.6.git;a=commitdiff_plain;h=06d2188644c85c56d243efab914f368d1d23c4a3
> 
> 
> The user which sent me the dmesg below tells that consecutive
> attempts to boot into X with the *nouveau* driver is generally
> not possible because of random lockups.
> 
> I'll have access to the machine in this week so I can try
> anything you want me to do.

This problem should be fixed now, we debugged it for a long time. E.g.
https://bugs.freedesktop.org/show_bug.cgi?id=23847

The commit:
http://cgit.freedesktop.org/nouveau/linux-2.6/commit/?id=7798546495c04a810db86be34ba1f39e370fd325
"drm/nouveau: fix missized allocation for ttm_bo_global struct"

I hope that solves your issue.

-- 
Pekka Paalanen
http://www.iki.fi/pq/
