Return-Path: <linux-kernel-owner+w=401wt.eu-S1761305AbXFWQxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761305AbXFWQxr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 12:53:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761071AbXFWQxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 12:53:25 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43221 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761056AbXFWQxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 12:53:23 -0400
Date: Sat, 23 Jun 2007 09:51:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com,
       cluster-devel@redhat.com, samba-technical@lists.samba.org,
       linux-ext4@vger.kernel.org
Subject: Re: [PATCH] zero_user_page conversion
Message-Id: <20070623095157.5a574afb.akpm@linux-foundation.org>
In-Reply-To: <4679A558.1010107@redhat.com>
References: <4679A558.1010107@redhat.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 20 Jun 2007 17:08:24 -0500 Eric Sandeen <sandeen@redhat.com> wrote:
> Use zero_user_page() in cifs, ocfs2, ext4, and gfs2 where possible.

One patch, splattered across four maintainers, each of whom maintain separate
trees.

Sigh.  Please, don't.  _someone_ has to split this up, and it might as well
not be me.

<splits it up>

