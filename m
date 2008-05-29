Return-Path: <linux-kernel-owner+w=401wt.eu-S1755865AbYE2DeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865AbYE2DeQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 23:34:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755413AbYE2Dd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 23:33:58 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:35878 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752676AbYE2Dd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 23:33:57 -0400
Date: Wed, 28 May 2008 22:33:53 -0500
From: Paul Jackson <pj@sgi.com>
To: miaox@cn.fujitsu.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, menage@google.com
Subject: Re: [RFC] [PATCH] cpusets: update tasks' cpus_allowed and
 mems_allowed after CPU/NODE offline/online
Message-Id: <20080528223353.61affb22.pj@sgi.com>
In-Reply-To: <483E1D77.30400@cn.fujitsu.com>
References: <483E1D77.30400@cn.fujitsu.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miao wrote:
> Though the patch is a little big, most of the change is just code restruction.

This looks like a nice bug fix - thanks!

Allow me to ask a question, but I hope you will be happy to answer yes
or no, either way, as you see it.

The question is:

  Would it be easy to split this patch into two pieces, where:
  1) the first piece contains the restructuring (but is still buggy), and
  2) the second piece has just the bug fix?

If that would be easy, that might make a nice way to present this fix.

If that would not be so easy, that's ok ... I can still review easily
enough.  I'll just have to drink an extra cup of coffee first, to make
my mind a little more alert <grin>.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
