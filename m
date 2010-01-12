Return-Path: <linux-kernel-owner+w=401wt.eu-S1754645Ab0ALBMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645Ab0ALBMs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 20:12:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754541Ab0ALBMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 20:12:47 -0500
Received: from kanga.kvack.org ([205.233.56.17]:57189 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752818Ab0ALBMr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 20:12:47 -0500
X-Greylist: delayed 1177 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Jan 2010 20:12:47 EST
Date: Mon, 11 Jan 2010 20:12:45 -0500
From: Benjamin LaHaise <bcrl@lhnet.ca>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Tejun Heo <tj@kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       Eric Dumazet <eric.dumazet@gmail.com>, Serge Hallyn <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 3/7] sysfs: Keep an nlink count on sysfs directories.
Message-ID: <20100112011245.GM5524@kvack.org>
References: <m1d41g9z3q.fsf@fess.ebiederm.org> <1263241315-19499-3-git-send-email-ebiederm@xmission.com> <4B4BC683.7060508@kernel.org> <20100112005308.GL5524@kvack.org> <m1vdf82ksy.fsf@fess.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1vdf82ksy.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 11, 2010 at 05:06:53PM -0800, Eric W. Biederman wrote:
> I don't see the link count as interesting enough to store more than
> 16bits for it.  Even with 32bits of storage for nlink sysfs would have
> to have to handle the rollover case as I am doing now.  So I don't
> see any advantage to storing more bits.

I'm not terribly concerned with what value gets returned, but rather about 
how long is spent calculating it.  Ideally, new sysfs directory entries 
can be inserted in an O(1) or other reasonable order operation.  I'll try 
to find some time to re-run my interface scaling tests with your latest 
changes.

		=ben
