Return-Path: <linux-kernel-owner+w=401wt.eu-S1754404AbZBCLst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404AbZBCLst (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 06:48:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752156AbZBCLsg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 06:48:36 -0500
Received: from mail2.shareable.org ([80.68.89.115]:46157 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786AbZBCLsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 06:48:35 -0500
Date: Tue, 3 Feb 2009 11:48:29 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, t-sato@yk.jp.nec.com
Subject: Re: [PATCH V4] Allow SysRq emergency thaw to thaw frozen filesystems
Message-ID: <20090203114829.GG11926@shareable.org>
References: <496EB639.6090800@redhat.com> <4970E087.8020308@redhat.com> <4970E4FB.7040407@redhat.com> <20090130134009.02d4a576.akpm@linux-foundation.org> <498779D6.7010304@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <498779D6.7010304@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Sandeen wrote:
> The timeout thaw originally proposed did not get merged, but
> perhaps something like this would be useful in emergencies.
> 
> For example, freeze /path/to/mountpoint may freeze your
> root filesystem if you forgot that you had that unmounted.

If you don't have console access, you're just logged in remotely, is
there a way to do an emergency unthaw from a shell command?

-- Jamie
