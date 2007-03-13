Return-Path: <linux-kernel-owner+w=401wt.eu-S933358AbXCMVIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933358AbXCMVIb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 17:08:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933365AbXCMVIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 17:08:31 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:3026 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933358AbXCMVIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 17:08:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ornZkbw6fSreiTgnWdiJFF5+csYDo9GUX0zXKYTdBVT+z5yNmSyIzXHhNhmHJEKFd/OsYh5S6ikT/SMmDR4ktWx7dSGLgJX9Xcy9uPA687K2Bp07W02eTaNz0jv223WfCVTzDQoh3d54sxg0319KSZvxdw7CCHj/rXD2wX1buck=
Message-ID: <d120d5000703131408p626498f4h27c2207c117ef355@mail.gmail.com>
Date: Tue, 13 Mar 2007 17:08:27 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Hugh Dickins" <hugh@veritas.com>
Subject: Re: 2.6.21-rc suspend regression: sysfs deadlock
Cc: "Alan Stern" <stern@rowland.harvard.edu>,
       "Oliver Neukum" <oneukum@suse.de>, "Maneesh Soni" <maneesh@in.ibm.com>,
       gregkh@suse.de, "Richard Purdie" <rpurdie@rpsys.net>,
       "James Bottomley" <James.Bottomley@steeleye.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Kernel development list" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0703132052560.24739@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.44L0.0703131604160.7744-100000@iolanthe.rowland.org>
	 <Pine.LNX.4.64.0703132052560.24739@blonde.wat.veritas.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/13/07, Hugh Dickins <hugh@veritas.com> wrote:
> On Tue, 13 Mar 2007, Alan Stern wrote:
> >
> > On the other hand, a quick survey of the kernel source shows that
> > DEVICE_ATTR is used over 1500 times.  Auditing all of them is not a job
> > for the faint-of-heart!
>
> Indeed, and faint-hearted Hugh wasn't intending to do so: but
> stout-hearted Alan will need to, won't he, before his patch can go in?
>

I think we could rely on subsystems maintainers to let us know if
there are potential problems. For example I can tell that neither
input, serio nor gameport subsystems use sysfs to destroy their
devices (action on sysfs may cause some other device to be destroyed
but that should be ok, only self-destruction is not allowed, right?)

-- 
Dmitry
