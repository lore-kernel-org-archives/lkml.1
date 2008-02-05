Return-Path: <linux-kernel-owner+w=401wt.eu-S1756169AbYBEKDo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169AbYBEKDo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 05:03:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754419AbYBEKDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 05:03:34 -0500
Received: from namei.org ([69.55.235.186]:54723 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754149AbYBEKDd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 05:03:33 -0500
Date: Tue, 5 Feb 2008 21:02:36 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Andrew Morton <akpm@linux-foundation.org>
cc: =?ISO-8859-1?Q?Oliver_Pinter_=28Pint=E9r_Oliv=E9r=29?= 
	<oliver.pntr@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org, Stephen Smalley <sds@tycho.nsa.gov>,
       Eric Paris <eparis@redhat.com>
Subject: Re: [2.6.24 REGRESSION] BUG: Soft lockup - with VFS
In-Reply-To: <20080204213911.1bcbaf66.akpm@linux-foundation.org>
Message-ID: <Xine.LNX.4.64.0802052100510.2122@us.intercode.com.au>
References: <6101e8c40801280031v1a860e90gfb3992ae5db37047@mail.gmail.com>
 <20080204213911.1bcbaf66.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="927316971-996416682-1202205756=:2122"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--927316971-996416682-1202205756=:2122
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Mon, 4 Feb 2008, Andrew Morton wrote:

> On Mon, 28 Jan 2008 09:31:43 +0100 "Oliver Pinter (Pintér Olivér)"  <oliver.pntr@gmail.com> wrote:
> 
> > hi all!
> > 
> > in the 2.6.24 become i some soft lockups with usb-phone, when i pluged
> > in the mobile, then the vfs-layer crashed. am afternoon can i the
> > .config send, and i bisected the kernel, when i have time.
> > 
> > pictures from crash:
> > http://students.zipernowsky.hu/~oliverp/kernel/regression_2624/
> 
> It looks like selinux's file_has_perm() is doing spin_lock() on an
> uninitialised (or already locked) spinlock.

Perplexing.

Do you have all of the lock debugging enabled?


- James
-- 
James Morris
<jmorris@namei.org>
--927316971-996416682-1202205756=:2122--
