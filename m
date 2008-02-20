Return-Path: <linux-kernel-owner+w=401wt.eu-S1761464AbYBTFRk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761464AbYBTFRk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 00:17:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751213AbYBTFRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 00:17:32 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:53944 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750903AbYBTFRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 00:17:31 -0500
Date: Tue, 19 Feb 2008 23:17:26 -0600
From: Paul Jackson <pj@sgi.com>
To: "Paul Menage" <menage@google.com>
Cc: lizf@cn.fujitsu.com, balbir@linux.vnet.ibm.com, balbir@in.ibm.com,
       xemul@openvz.org, kamezawa.hiroyu@jp.fujitsu.com,
       vatsa@linux.vnet.ibm.com, akpm@linux-foundation.org,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 1/7] CGroup API: Add cgroup.api control file
Message-Id: <20080219231726.4bd97520.pj@sgi.com>
In-Reply-To: <6599ad830802191851l66281e67rb49c766c2b1427c9@mail.gmail.com>
References: <20080215204418.535025000@menage.corp.google.com>
	<20080215204820.734926000@menage.corp.google.com>
	<47B6B5CA.7040201@linux.vnet.ibm.com>
	<6599ad830802160944v6d529570k1ade6df273ca3d0d@mail.gmail.com>
	<47B953A8.9030206@cn.fujitsu.com>
	<20080219155742.0298f25f.pj@sgi.com>
	<6599ad830802191851l66281e67rb49c766c2b1427c9@mail.gmail.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul M wrote:
> I guess it's not essential, I just figured that if we had that
> information, it made sense to make it available to userspace. I guess
> I'm happy with dropping the actual exposed cgroup.api file for now as
> long as we can work towards reducing the number of control files that
> just return strings, and make use of the structured output such as
> read_uint() miore.

I could certainly go along with that ... reducing the proportion of
control files returning untyped strings.

My sense of kernel-user API's is that usually the less said the better.
Identify the essential information that one side requires from the
other via a runtime API, and pass only that.  API's represent a
lifetime commitment, so the less promised the better.

Perhaps my primary concern with these *.api files was that I did not
understand who or what the critical use or user was; who found this
essential, not just nice to have.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
