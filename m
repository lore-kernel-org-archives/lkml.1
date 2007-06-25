Return-Path: <linux-kernel-owner+w=401wt.eu-S1754959AbXFYQZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959AbXFYQZ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 12:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752213AbXFYQZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 12:25:17 -0400
Received: from canuck.infradead.org ([209.217.80.40]:45262 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825AbXFYQZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 12:25:15 -0400
Subject: Re: [RFC] mm-controller
From: Peter Zijlstra <peterz@infradead.org>
To: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: balbir@linux.vnet.ibm.com, Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.osdl.org>,
       linux-mm <linux-mm@kvack.org>, Balbir Singh <balbir@in.ibm.com>,
       Pavel Emelianov <xemul@sw.ru>, Paul Menage <menage@google.com>,
       Kirill Korotaev <dev@sw.ru>, devel@openvz.org,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Herbert Poetzl <herbert@13thfloor.at>, Roy Huang <royhuang9@gmail.com>,
       Aubrey Li <aubreylee@gmail.com>, riel@redhat
In-Reply-To: <467BFA47.4050802@linux.vnet.ibm.com>
References: <1182418364.21117.134.camel@twins>
	 <467A5B1F.5080204@linux.vnet.ibm.com> <1182433855.21117.160.camel@twins>
	 <467BFA47.4050802@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Mon, 25 Jun 2007 18:22:41 +0200
Message-Id: <1182788561.6174.70.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-22 at 22:05 +0530, Vaidyanathan Srinivasan wrote:

> Merging both limits will eliminate the issue, however we would need
> individual limits for pagecache and RSS for better control.  There are
> use cases for pagecache_limit alone without RSS_limit like the case of
> database application using direct IO, backup applications and
> streaming applications that does not make good use of pagecache.

I'm aware that some people want this. However we rejected adding a
pagecache limit to the kernel proper on grounds that reclaim should do a
better job.

And now we're sneaking it in the backdoor.

If we're going to do this, get it in the kernel proper first.

