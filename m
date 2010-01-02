Return-Path: <linux-kernel-owner+w=401wt.eu-S1752777Ab0ABPkl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777Ab0ABPkl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 10:40:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752629Ab0ABPkl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 10:40:41 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:48507 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646Ab0ABPkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 10:40:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=dohsnouXMmWP0Fp/Z9DbVgNZafefF/Biy8Yq1qKPiEKTjHFVNkuHYil/Ul79aEdErc
         9kCRZnCmbFXq6PToFYrLB2I91vpw+hiXXOnuVQES4qn3/9SjljUXdZDE0+vHOML5jMvq
         YB4UL29M4efXxwCAsVjb24App34HUkYZRjzlg=
Date: Sat, 2 Jan 2010 16:40:31 +0100
From: Borislav Petkov <petkovbb@googlemail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       David Airlie <airlied@linux.ie>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH] sysfs: Cache the last sysfs_dirent to improve readdir
 scalability v2
Message-ID: <20100102154031.GA21729@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@googlemail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
	David Airlie <airlied@linux.ie>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Greg KH <greg@kroah.com>, Al Viro <viro@ZenIV.linux.org.uk>
References: <20091228092712.AA8C.A69D9226@jp.fujitsu.com>
 <alpine.LFD.2.00.0912301259220.11961@localhost.localdomain>
 <m11victac1.fsf@fess.ebiederm.org>
 <alpine.LFD.2.00.0912301348320.11961@localhost.localdomain>
 <m1fx6rtu31.fsf@fess.ebiederm.org>
 <alpine.LFD.2.00.0912311043330.11961@localhost.localdomain>
 <m11viaexlj.fsf_-_@fess.ebiederm.org>
 <alpine.LFD.2.00.1001011047580.3630@localhost.localdomain>
 <m1y6kh30pi.fsf_-_@fess.ebiederm.org>
 <alpine.LFD.2.00.1001011501340.3630@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1001011501340.3630@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 01, 2010 at 03:10:49PM -0800, Linus Torvalds wrote:
> And by "testing" I mean both the "yes, this second version also breaks the 
> lockdep chain and avoids the warning",

Yes, it survived a couple of suspend/resume cycles so far.

-- 
Regards/Gruss,
    Boris.
