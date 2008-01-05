Return-Path: <linux-kernel-owner+w=401wt.eu-S1756558AbYAEQoj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756558AbYAEQoj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 11:44:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755568AbYAEQob
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 11:44:31 -0500
Received: from mail.fieldses.org ([66.93.2.214]:36307 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755449AbYAEQoa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 11:44:30 -0500
Date: Sat, 5 Jan 2008 11:44:03 -0500
To: Tomasz =?utf-8?Q?K=C5=82oczko?= <kloczek@rudy.mif.pg.gda.pl>
Cc: Jeff Layton <jlayton@redhat.com>, linux-nfs@vger.kernel.org,
       nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       richterd@citi.umich.edu
Subject: Re: [PATCH 0/7] Intro: convert lockd to kthread and fix
	use-after-free (try #3)
Message-ID: <20080105164403.GA12928@fieldses.org>
References: <1198009182-27895-1-git-send-email-jlayton@redhat.com> <Pine.BSO.4.63.0712192004140.3875@rudy.mif.pg.gda.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.BSO.4.63.0712192004140.3875@rudy.mif.pg.gda.pl>
User-Agent: Mutt/1.5.17 (2007-11-01)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2007 at 08:15:43PM +0100, Tomasz Kłoczko wrote:
> On Tue, 18 Dec 2007, Jeff Layton wrote:
>
>> This is the third patchset to fix the use-after-free problem in lockd,
>> and to convert lockd to use the kthread API instead of kernel_thread.
>> The main change from the last patchset is the elimination of the
>> svc_create_kthread helper function, and having lockd_up call kthread_run
>> directly. I've also made some changes to the function prototype for
>> the lockd function to eliminate the need for casting the function
>> pointer.
>
> BTW kernel, NFS and lockd: SuSE kernel IIRC is distributed with patch which 
> adds kernel-based status monitor (statd).
>
> Q to NFS people: any plans about merge this in main kernel tree ?

No.  There was opposition to the idea.  I can't remember the argument,
though, and a quick google search isn't turning it up.

> And another question related to NFS: any progress on add clear NFS 
> statistics in kernel (nfsstat -z) ?

No.  We do have some patches that add roughly equivalent functionality
in userspace.

--b.
