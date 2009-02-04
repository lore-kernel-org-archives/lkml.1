Return-Path: <linux-kernel-owner+w=401wt.eu-S1758747AbZBDXqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758747AbZBDXqA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 18:46:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752641AbZBDXpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 18:45:50 -0500
Received: from yw-out-2324.google.com ([74.125.46.31]:30529 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163AbZBDXpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 18:45:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=EmDRy/fMyhg0CZnFTbuF+P8TVQL+PMlFjs4yqqFy8kY0+9pnlX4xvTygLToGTG511M
         b4WRzMD1dcctOiIMHso8rR/kpwXsUcjoLbVLPm7E2rcnXDdTY2nT5/fx7N7YomlkmqVa
         3xOO4Nn3s7bGk0YuYyNoRN48xF7Up7iqdtVlI=
MIME-Version: 1.0
In-Reply-To: <20090204150507.665b5b7c.akpm@linux-foundation.org>
References: <alpine.DEB.1.10.0902041349180.6214@alien.or.mcafeemobile.com>
	 <20090204150507.665b5b7c.akpm@linux-foundation.org>
Date: Wed, 4 Feb 2009 15:45:47 -0800
Message-ID: <a36005b50902041545qb9ce459y710bb3b9b8949b17@mail.gmail.com>
Subject: Re: [patch/rfc] eventfd semaphore-like behavior
From: Ulrich Drepper <drepper@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Davide Libenzi <davidel@xmailserver.org>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, mtk.manpages@gmail.com,
       linux-api@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 4, 2009 at 3:05 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> How would you recommend that userspace determine whether its kernel
> supports this feature, bearing in mind that someone might backport this
> patch into arbitrarily earlier kernel versions?

   fd = eventfd2 (CNT, EFD_SEMAPHORE);
   if (fd == -1 && errno == EINVAL)
     puts("cannot handled EFD_SEMAPHORE");
