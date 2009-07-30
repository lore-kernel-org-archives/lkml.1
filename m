Return-Path: <linux-kernel-owner+w=401wt.eu-S1755807AbZG3ANB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807AbZG3ANB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 20:13:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755679AbZG3ANA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 20:13:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49154 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755599AbZG3ANA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 20:13:00 -0400
Date: Wed, 29 Jul 2009 17:12:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: alexander.shishckin@gmail.com
Cc: linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org, alexander.shishckin@gmail.com
Subject: Re: [PATCH] [RESEND] RFC: List per-process file descriptor
 consumption when hitting file-max
Message-Id: <20090729171248.764570f2.akpm@linux-foundation.org>
In-Reply-To: <1244538071-992-1-git-send-email-alexander.shishckin@gmail.com>
References: <1244538071-992-1-git-send-email-alexander.shishckin@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  9 Jun 2009 12:01:11 +0300
alexander.shishckin@gmail.com wrote:

> When a file descriptor limit is hit, it might be useful to see all the
> users to be able to identify those that leak descriptors.

Well... maybe.

There is no end to the amount of code which we could add to the kernel
to help userspace developers and administrators resolve userspace bugs.
But that doesn't mean that we should add all these things to the
kernel.

If there's some reason why the problem is particularly severe and
particularly hard to resolve by other means then sure, perhaps explicit
kernel support is justified.  But is that the case with this specific
userspace bug?


