Return-Path: <linux-kernel-owner+w=401wt.eu-S1752029AbXAXQ6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029AbXAXQ6u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 11:58:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752026AbXAXQ6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 11:58:50 -0500
Received: from mx1.redhat.com ([66.187.233.31]:55733 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752017AbXAXQ6t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 11:58:49 -0500
Message-ID: <45B78FF9.40202@redhat.com>
Date: Wed, 24 Jan 2007 11:57:29 -0500
From: Jeff Layton <jlayton@redhat.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Eric Dumazet <dada1@cosmosbay.com>
CC: Andrew Morton <akpm@osdl.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] i_ino uniqueness: alternate approach -- hash the
 inodes
References: <200701161857.l0GIvcaA016196@dantu.rdu.redhat.com> <20070123204648.204b1834.akpm@osdl.org> <45B76BAC.4040408@redhat.com> <200701241621.44923.dada1@cosmosbay.com>
In-Reply-To: <200701241621.44923.dada1@cosmosbay.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:
 > The problem is you wont see the overhead of insert/delete the inode in a
 > global tree, since you keep hot caches.
 >
 > To have a better estimate of the overhead, I suggest you try to use more
 > active pipes like :
 >

Eric, thanks for the new program. With that, the situation looks slightly
worse:

hashing patch (pipebench):
sys     1m15.329s
sys     1m16.249s
sys     1m17.169s

unpatched (pipebench):
sys     1m9.836s
sys     1m12.541s
sys     1m14.153s

Which works out to 1.05642174294555027017. So ~5-6%.

-- Jeff

