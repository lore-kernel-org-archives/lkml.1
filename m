Return-Path: <linux-kernel-owner+w=401wt.eu-S932519AbYEGHoF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932519AbYEGHoF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 03:44:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753295AbYEGHnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 03:43:53 -0400
Received: from smtp-out.google.com ([216.239.33.17]:35195 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756078AbYEGHnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 03:43:51 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=LsAUuaMPuqb1Ol5TJmwk0fgy7yZWiM5R7wzVAIf7ab9sji/iGMOBmnG16JpQ7jENg
	QYebCUK75ftLjKFCv7xuQ==
Message-ID: <6599ad830805070043y4465a32h8e26c5e8890b1100@mail.gmail.com>
Date: Wed, 7 May 2008 00:43:45 -0700
From: "Paul Menage" <menage@google.com>
To: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] mm/cgroup.c add error check
Cc: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       "Li Zefan" <lizf@cn.fujitsu.com>
In-Reply-To: <20080507164526.884208f9.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080506195216.4A6D.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <6599ad830805062208if98157cwaca4bafa01b8d097@mail.gmail.com>
	 <20080507164526.884208f9.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 7, 2008 at 12:45 AM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
>  Hmm, but It seems call_usermodehelper()'s fails in silent, no messages.
>  A notify which can be silently dropped is useless.

True, but if we're so short of memory that we can't fork, userspace
probably won't be able to do much about the notification even if it
gets it.

>  Can we add 'printk("notify_on_release: ... is failed")' or some workaround ?
>

Sounds reasonable for debugging, but don't expect any automated
middleware to notice it.

Paul
