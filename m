Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756407Ab0BBU7M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 15:59:12 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:57320 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756343Ab0BBU7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 15:59:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        b=NZ0huNZISC7NGUonfGUjs22xyUec1Y/M6HF+qihy3YwvVYHsZNu9cDDowpCRzHrDUq
         U252+9ZxKouxLvn/qze5nSQnyDE5o8kErpZfHhofLTmgQSUr9g17Xc2bhaFmU57+K8Nl
         xpxFeVT1FojXyaIgp0L6sIBMTVzintgH1MaI4=
Date: Tue, 2 Feb 2010 21:58:57 +0100
From: Borislav Petkov <petkovbb@googlemail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       DRI <dri-devel@lists.sourceforge.net>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>,
       Greg KH <greg@kroah.com>
Subject: Re: [Bug #14949] drm_vm.c:drm_mmap: possible circular locking
 dependency detected
Message-ID: <20100202205857.GA30024@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@googlemail.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	DRI <dri-devel@lists.sourceforge.net>,
	"Eric W. Biederman" <ebiederm@aristanetworks.com>,
	Greg KH <greg@kroah.com>
References: <vZZJKzCUn4G.A.CPB.F7hZLB@chimera>
 <d3IDKWHT5gE.A.DLD.q8hZLB@chimera>
 <9ea470501002011001s7734a20ft4dd5d181baf714c3@mail.gmail.com>
 <201002022146.45078.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201002022146.45078.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Adding Greg to Cc:)

On Tue, Feb 02, 2010 at 09:46:45PM +0100, Rafael J. Wysocki wrote:
> On Monday 01 February 2010, Borislav Petkov wrote:
> > On Mon, Feb 1, 2010 at 1:22 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > This message has been generated automatically as a part of a report
> > > of recent regressions.
> > >
> > > The following bug entry is on the current list of known regressions
> > > from 2.6.32.  Please verify if it still should be listed and let me know
> > > (either way).
> > >
> > >
> > > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=14949
> > > Subject         : drm_vm.c:drm_mmap: possible circular locking dependency detected
> > > Submitter       : Borislav Petkov <petkovbb@googlemail.com>
> > > Date            : 2009-12-26 9:45 (37 days old)
> > > References      : http://marc.info/?l=linux-kernel&m=126182073616279&w=4
> > > Handled-By      : Eric W. Biederman <ebiederm@aristanetworks.com>
> > > Patch           : http://patchwork.kernel.org/patch/70461/
> > 
> > Yes, this is fixed.
> 
> Do you mean "fixed" as "the fix is in the Linus' tree" or "fixed" as "the
> patch fixed it for me"?

Rather the second one, i.e. it fixes it for me. The patch is named

sysfs-cache-the-last-sysfs_dirent-to-improve-readdir-scalability-v2.patch

and is "stuck" in Greg's tree. Judging by the quilt series¹, the patch
is slated for submission after 2.6.33. This late in the game for .32,
I'm guessing maybe a stable backport after .33 is out?

[1] http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/series

-- 
Regards/Gruss,
    Boris.
