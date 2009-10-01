Return-Path: <linux-kernel-owner+w=401wt.eu-S1756212AbZJANUh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212AbZJANUh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 09:20:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756107AbZJANUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 09:20:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1851 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756100AbZJANUf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 09:20:35 -0400
Date: Thu, 1 Oct 2009 10:20:12 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Shirley Ma <mashirle@us.ibm.com>
Cc: virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: INFO: task journal:337 blocked for more than 120 seconds
Message-ID: <20091001132012.GA16975@amt.cnet>
References: <1254345112.8837.9.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254345112.8837.9.camel@localhost.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 30, 2009 at 02:11:52PM -0700, Shirley Ma wrote:
> Hello all,
> 
> Anybody found this problem before? I kept hitting this issue for 2.6.31
> guest kernel even with a simple network test.
> 
> INFO: task kjournal:337 blocked for more than 120 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_sec" disables this message.
> 
> kjournald	D 00000041	0	337	2 0x00000000
> 
> My test is totally being blocked.

I've hit this in the past with ext3, mounting with data=writeback made it
disappear.

