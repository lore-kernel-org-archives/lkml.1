Return-Path: <linux-kernel-owner+w=401wt.eu-S1758946AbYEGBt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758946AbYEGBt4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 21:49:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752201AbYEGBtr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 21:49:47 -0400
Received: from relay1.sgi.com ([192.48.171.29]:53308 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751967AbYEGBtr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 21:49:47 -0400
Date: Tue, 6 May 2008 20:49:46 -0500
From: Paul Jackson <pj@sgi.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: akpm@linux-foundation.org, menage@google.com,
       seto.hidetoshi@jp.fujitsu.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix cpuset sched_relax_domain_level control file
Message-Id: <20080506204946.7754302d.pj@sgi.com>
In-Reply-To: <482109E5.5050204@cn.fujitsu.com>
References: <48210101.1070205@google.com>
	<20080506183841.e1771032.akpm@linux-foundation.org>
	<482109E5.5050204@cn.fujitsu.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Or maybe we can restrict the value from -1 to 5 ?

That might be a good idea.  My recollection is that this
is what we tell users to input ... values between -1 and
some small positive integer.  So returning -EINVAL on an
input of -2 (for example) should be the least surprising
behaviour for users.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
