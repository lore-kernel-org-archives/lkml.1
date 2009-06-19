Return-Path: <linux-kernel-owner+w=401wt.eu-S1755411AbZFSIos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411AbZFSIos (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 04:44:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753370AbZFSIok
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 04:44:40 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:37707 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656AbZFSIoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 04:44:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=PIJYexi2lHjPHJ0U5Sm3dbQx4mVx9OqUf/2fc30zn1M9JQ03BTfEMrXggqx6zG5+6N
         K36R7HB03J/vvtwVyvzk+h4gDoz/zQfEIG9K35KiNl0Qwng+JJEAmmkn49Hn/lza5+El
         Fj+6/0SZDsRKBjnat69at9/RjhJodFCe+IGJ4=
Date: Fri, 19 Jun 2009 10:45:31 +0200
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus <torvalds@linux-foundation.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: origin tree build warning
Message-Id: <20090619104531.98e9058c.kristoffer.ericson@gmail.com>
In-Reply-To: <20090619111359.b317a533.sfr@canb.auug.org.au>
References: <20090619111359.b317a533.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

Hmm, this would be true if you are using the s1d13xxxfb driver without having supported 2D accel (essentially everything not 13506). Atleast
for bltbit_wait_bitset. The bltbit_fifo_status on the other hand is needed later on
for image blitting, which is coming.

The point is basicly this, all s1d13xxxfb cards should get their 2D acceleration
going so until then this is just an annoying but harmless warning.

Hope that answers your comment.

Best wishes
Kristoffer

On Fri, 19 Jun 2009 11:13:59 +1000
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Linus,
> 
> Today's linux-next build (x86_64 allmodconfig) produced this warning:
> 
> drivers/video/s1d13xxxfb.c:420: warning: 'bltbit_wait_bitset' defined but not used
> drivers/video/s1d13xxxfb.c:463: warning: 'bltbit_fifo_status' defined but not used
> 
> Introduced by commit 3ed167af96ed098187ea41353fe02d1af20d38a1 ("fbdev:
> s1d13xxxfb: add accelerated bitblt functions").
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/
> 


-- 
Kristoffer Ericson <kristoffer.ericson@gmail.com>
