Return-Path: <linux-kernel-owner+w=401wt.eu-S1754936AbZBCNbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936AbZBCNbV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 08:31:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752417AbZBCNbM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 08:31:12 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:48808 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371AbZBCNbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 08:31:11 -0500
Subject: Re: [PATCH V4] Allow SysRq emergency thaw to thaw frozen
 filesystems
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Jamie Lokier <jamie@shareable.org>
Cc: Eric Sandeen <sandeen@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       t-sato@yk.jp.nec.com
In-Reply-To: <20090203114829.GG11926@shareable.org>
References: <496EB639.6090800@redhat.com> <4970E087.8020308@redhat.com>
	 <4970E4FB.7040407@redhat.com>
	 <20090130134009.02d4a576.akpm@linux-foundation.org>
	 <498779D6.7010304@redhat.com>  <20090203114829.GG11926@shareable.org>
Content-Type: text/plain
Date: Tue, 03 Feb 2009 07:31:07 -0600
Message-Id: <1233667867.30906.0.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-03 at 11:48 +0000, Jamie Lokier wrote:
> Eric Sandeen wrote:
> > The timeout thaw originally proposed did not get merged, but
> > perhaps something like this would be useful in emergencies.
> > 
> > For example, freeze /path/to/mountpoint may freeze your
> > root filesystem if you forgot that you had that unmounted.
> 
> If you don't have console access, you're just logged in remotely, is
> there a way to do an emergency unthaw from a shell command?

echo j > /proc/sysrq-trigger

Shaggy
-- 
David Kleikamp
IBM Linux Technology Center

