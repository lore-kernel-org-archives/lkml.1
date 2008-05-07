Return-Path: <linux-kernel-owner+w=401wt.eu-S1758172AbYEGB7K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758172AbYEGB7K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 21:59:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754143AbYEGB6z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 21:58:55 -0400
Received: from relay2.sgi.com ([192.48.171.30]:55808 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750963AbYEGB6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 21:58:54 -0400
Date: Tue, 6 May 2008 20:58:52 -0500
From: Paul Jackson <pj@sgi.com>
To: "Paul Menage" <menage@google.com>
Cc: lizf@cn.fujitsu.com, akpm@linux-foundation.org,
       seto.hidetoshi@jp.fujitsu.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix cpuset sched_relax_domain_level control file
Message-Id: <20080506205852.8adaa0a2.pj@sgi.com>
In-Reply-To: <6599ad830805061851n767ff7a1qc8cb850ec98ad60d@mail.gmail.com>
References: <48210101.1070205@google.com>
	<20080506183841.e1771032.akpm@linux-foundation.org>
	<482109E5.5050204@cn.fujitsu.com>
	<20080506204946.7754302d.pj@sgi.com>
	<6599ad830805061851n767ff7a1qc8cb850ec98ad60d@mail.gmail.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul M wrote:
> I was just trying to get close to the original behaviour.

An honorable goal.

Li Zefan - would you be interested in generating a patch
that fails -EINVAL for inputs outside the range of [-1 ... N]
for whatever small positive N the kernel recognizes?

This seems like a minor enough difference that I for one
don't have any problem with the current code, remapping
all negative inputs to -1, going in, and then a follow-on
patch changing that going in afterward.

Of course, if you or Seto-san prefer the current behaviour,
it would be easy to persuade me to agree.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
