Return-Path: <linux-kernel-owner+w=401wt.eu-S1756360AbYBHNzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756360AbYBHNzh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 08:55:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756754AbYBHNy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 08:54:56 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:29395 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756306AbYBHNyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 08:54:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=g8e07EeMcRw3+aC74IRrJ5hjeQT9n1fBWVk1JQKC/dv3uZiHv/8tXfW+SqxAi5ZUfGTRviEN6pqs9vK7ZtRvpg1bQhvc6wu6JwNEYNKC4Ac9YbL1Y7n+JqXjLBSc3w/E8GQzVdlfiKFID9tBA8n100Z90TRwAuvjKj14JDWyV3E=
Message-ID: <3d8471ca0802080554pfecb2v32dcb8ece0da346a@mail.gmail.com>
Date: Fri, 8 Feb 2008 14:54:51 +0100
From: "Guillaume Chazarain" <guichaz@gmail.com>
To: akpm@linux-foundation.org
Subject: Re: [patch 019/233] proc: fix the threaded /proc/self
Cc: torvalds@linux-foundation.org, ebiederm@xmission.com, mingo@elte.hu,
       oleg@tv-sign.ru, rjw@sisk.pl, roland@redhat.com, xemul@openvz.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <200802081218.m18CIHEx023631@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200802081218.m18CIHEx023631@imap1.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 8, 2008 1:18 PM,  <akpm@linux-foundation.org> wrote:
> Long ago when the CLONE_THREAD support first went it someone thought it
> would be wise to point /proc/self at /proc/<tgid> instead of /proc/<pid>.

The last message about this conversation is:

http://lkml.org/lkml/2007/12/1/172

So I thought we would end up with a new file, in order to make the
change discoverable.

-- 
Guillaume
