Return-Path: <linux-kernel-owner+w=401wt.eu-S1757790AbZKYPX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757790AbZKYPX3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 10:23:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753284AbZKYPX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 10:23:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14006 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752553AbZKYPX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 10:23:28 -0500
Subject: Re: linux-next: manual merge of the ext3 tree with the cifs tree
From: Eric Paris <eparis@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jan Kara <jack@suse.cz>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Steve French <sfrench@us.ibm.com>, Jeff Layton <jlayton@redhat.com>
In-Reply-To: <20091125200444.cab8f918.sfr@canb.auug.org.au>
References: <20091125140626.2b71fb0a.sfr@canb.auug.org.au>
	 <20091125085006.GB549@quack.suse.cz>
	 <20091125200444.cab8f918.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 Nov 2009 10:23:03 -0500
Message-Id: <1259162583.4683.46.camel@dhcp231-106.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-11-25 at 20:04 +1100, Stephen Rothwell wrote:

> I have just noticed that I get the same conflict between the cifs tree
> and the fsnotify tree (hi Eric!) which has also included that patch from
> Christoph.  Again, not a big problem.

I was doing my development against linux-next.  After I posted them and
decided to commit them to my -next tree I realized they didn't commit
due to hch's patch.  So I cherry picked hch's patch and decided I
wouldn't ask linus to pull until after the hch patch went in (I did it
for some things in the net-next tree as well as I recall)

What's the best way?  To handle this?  do you prefer to just carry the
conflict fix?  should we cherry pick things and fix it ourselves?  I
guess my method breaks down if the tree in question doesn't eventually
go to linus like it should.....

-Eric

