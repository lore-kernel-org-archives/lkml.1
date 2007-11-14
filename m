Return-Path: <linux-kernel-owner+w=401wt.eu-S1763376AbXKNSjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763376AbXKNSjl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 13:39:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758229AbXKNSjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 13:39:31 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:47359 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756343AbXKNSjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 13:39:31 -0500
Date: Wed, 14 Nov 2007 10:39:30 -0800
From: Micah Dowty <micah@vmware.com>
To: Cyrus Massoumi <cyrusm@gmx.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: High priority tasks break SMP balancer?
Message-ID: <20071114183929.GA9287@vmware.com>
References: <20071109223417.GB16250@vmware.com> <4734F397.7080802@gmx.net> <20071110001103.GD16250@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071110001103.GD16250@vmware.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 09, 2007 at 04:11:03PM -0800, Micah Dowty wrote:
> It's also possible this problem doesn't occur on 2.6.17. I have only
> tested this example on 2.6.23.1 and 2.6.20 so far.

I tested a handful of kernel versions, and it looks like this is
indeed the case. As far as I can tell, this problem was introduced
between 2.6.19.7 and 2.6.20.

Looking at the diff between those versions, it looks like there were
some noteworthy changes to the SMP balancer. I'm still working on
narrowing this down further.

Thanks,
--Micah
