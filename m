Return-Path: <linux-kernel-owner+w=401wt.eu-S1758543AbZLIWpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758543AbZLIWpj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 17:45:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758514AbZLIWpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 17:45:36 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:47032 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758495AbZLIWpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 17:45:33 -0500
Date: Wed, 9 Dec 2009 22:45:36 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: jim owens <jowens@hp.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, mst@redhat.com,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] export use_mm and unuse_mm for filesystem modules.
Message-ID: <20091209224536.GT14381@ZenIV.linux.org.uk>
References: <4B20277B.1030903@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B20277B.1030903@hp.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 09, 2009 at 05:40:59PM -0500, jim owens wrote:
>
> required for btrfs directio worker threads.

Careful.  It's very easy to fsck up on biarch architectures with
that stuff.
