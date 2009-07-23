Return-Path: <linux-kernel-owner+w=401wt.eu-S1753008AbZGWDF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008AbZGWDF1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 23:05:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752886AbZGWDF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 23:05:26 -0400
Received: from mail.windriver.com ([147.11.1.11]:64626 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752376AbZGWDFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 23:05:25 -0400
Message-ID: <4A67D36D.8070209@windriver.com>
Date: Wed, 22 Jul 2009 22:05:17 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next:  kgdb tree fetch failure
References: <20090723090956.e6024af4.sfr@canb.auug.org.au>
In-Reply-To: <20090723090956.e6024af4.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Jul 2009 03:05:19.0004 (UTC) FILETIME=[68F3DDC0:01CA0B42]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi Jason,
>
> Today's linux-next fetch of the kgdb tree failed like this:
>
> kgdb: git
> fatal: Couldn't find remote ref refs/heads/kgdb-next
> fatal: The remote end hung up unexpectedly
>
> So I will use the kgdb tree from yesterday (which actually dates from
> May).
>
>   
In the several years I have been using git, I have never seen it get
corrupted until today.

My local git repository completely bailed, so I am going to reconstruct
the kgdb branches from a new clone.  There was no obvious way to recover
my archive. 

Here is what it said:

% git push --force
ssh://master.kernel.org/staging/jwessel/linux-2.6-kgdb.git kgdb-next
fatal: bad object 4be3bd7849165e7efa6b0b35a23d6a3598d97465
error: pack-objects died with strange error
error: failed to push some refs to
'ssh://master.kernel.org/staging/jwessel/linux-2.6-kgdb.git'

I'll leave the archive around for a while, as it is nothing more than a
science project as a curiosity of how you recover from such a state.

Jason.

