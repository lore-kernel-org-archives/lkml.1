Return-Path: <linux-kernel-owner+w=401wt.eu-S1755200AbZJCLPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200AbZJCLPU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 07:15:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755063AbZJCLPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 07:15:20 -0400
Received: from smtp-out-045.synserver.de ([212.40.180.45]:1027 "HELO
	smtp-out-045.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754944AbZJCLPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 07:15:19 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: markus@trippelsdorf.de
X-SynServer-PPID: 30615
Date: Sat, 3 Oct 2009 13:15:15 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Roberto Oppedisano <roberto.oppedisano@infracom.it>
Cc: LKML <linux-kernel@vger.kernel.org>, tytso@mit.edu, adilger@sun.com,
       linux-ext4@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: kernel BUG at fs/ext4/inode.c:1184!
Message-ID: <20091003111515.GA2032@phenom2.trippelsdorf.de>
References: <4AC71ECC.2020104@infracom.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AC71ECC.2020104@infracom.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 03, 2009 at 11:52:12AM +0200, Roberto Oppedisano wrote:
> This is 100% reproducible on current git kernel.
> After hitting the BUG the machine is still alive, but some processes
> refuse to start and /bin/sync stalls forever.
> Last known good kernel is 2.6.32-rc2-00087-g9c1fe83.
> 
> [   74.971246] ------------[ cut here ]------------
> [   74.971303] kernel BUG at fs/ext4/inode.c:1184!

This is already fixed, see:
http://marc.info/?l=linux-ext4&m=125437926005433&w=4

Unfortunately Linus has not pulled the fix yet.
-- 
Markus
