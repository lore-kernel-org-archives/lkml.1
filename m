Return-Path: <linux-kernel-owner+w=401wt.eu-S1030339AbXDZKRy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030339AbXDZKRy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 06:17:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030505AbXDZKRy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 06:17:54 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:10465 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030339AbXDZKRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 06:17:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=sXU/karJkdi5tkXk5Xv27Yy45R5FIvR5y7j/D9LBmDL8trBBP1C4nISZFoG9yav0dhyCAbTpTtzgj6ah0AqrfhVHCYJK0RRmjkzQoLnTMZFD2GhilZe/ZjSeZL6SfyLgdMEpPt15csF+qrqTFxtPa2i7Imoe4CjxgCjx93lMfYI=
Message-ID: <9a8748490704260317u211c244au3c5478ac02c12c43@mail.gmail.com>
Date: Thu, 26 Apr 2007 12:17:47 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "David Chinner" <dgc@sgi.com>
Subject: Re: 2.6.20.3 - possible recursive locking detected - in XFS
Cc: linux-kernel@vger.kernel.org, xfs-masters@oss.sgi.com, xfs@oss.sgi.com,
       viro@zeniv.linux.org.uk
In-Reply-To: <20070425233345.GN48531920@melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200704251116.57737.jesper.juhl@gmail.com>
	 <20070425233345.GN48531920@melbourne.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/04/07, David Chinner <dgc@sgi.com> wrote:
> On Wed, Apr 25, 2007 at 11:16:57AM +0200, Jesper Juhl wrote:
> >
> > Hi,
> >
> > For your information :
> >
> > Once in a while I see the message below after I've just created a new XFS filesystem, mount it and then start copying data to it.
>
> .....
>
> > =============================================
> > [ INFO: possible recursive locking detected ]
> > 2.6.20.3generic #1
> > ---------------------------------------------
> > xfs_fsr/6117 is trying to acquire lock:
> >  (&(&ip->i_lock)->mr_lock){----}, at: [<f929422d>] xfs_ilock+0x7d/0xa0 [xfs]
> >
> > but task is already holding lock:
> >  (&(&ip->i_lock)->mr_lock){----}, at: [<f929422d>] xfs_ilock+0x7d/0xa0 [xfs]
>
> Known false positive - XFS doesn't have the annotations needed for
> this yet; we've got a patch that will probably make it's way into 6.5.22 that
> should fix most of these issues.
>
Ok. Thanks for the feedback.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
