Return-Path: <linux-kernel-owner+w=401wt.eu-S1753667AbYH2QAV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753667AbYH2QAV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 12:00:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751184AbYH2QAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 12:00:08 -0400
Received: from smtp-noauth7.primus.ca ([216.254.180.38]:54960 "EHLO
	mail-06.primus.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750964AbYH2QAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 12:00:07 -0400
X-Greylist: delayed 1930 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Aug 2008 12:00:07 EDT
Date: Fri, 29 Aug 2008 11:27:33 -0400
From: Nick Bowler <nbowler@ellipticsemi.com>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       fuse-devel@lists.sourceforge.net, miklos@szeredi.hu, greg@kroah.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] CUSE: implement CUSE - Character device in
	Userspace
Message-ID: <20080829152733.GA20151@finial.ellipticsemi.com>
Mail-Followup-To: Tejun Heo <tj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	fuse-devel@lists.sourceforge.net, miklos@szeredi.hu, greg@kroah.com,
	linux-kernel@vger.kernel.org
References: <1219947544-666-1-git-send-email-tj@kernel.org> <1219947544-666-6-git-send-email-tj@kernel.org> <20080828130740.344f7213.akpm@linux-foundation.org> <48B75A4C.60004@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48B75A4C.60004@kernel.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04:09 Fri 29 Aug     , Tejun Heo wrote:
> Hello, Andrew.
> 
> Andrew Morton wrote:
> >> +struct cuse_conn {
> >> +	struct fuse_conn	fc;
> >> +	struct cdev		cdev;
> >> +	struct vfsmount		*mnt;
> >> +	struct device		*dev;
> >> +	bool			cdev_added:1;
> >> +	bool			disconnected:1;	/* channel disconnected */
> > 
> > I didn't know you could do that with bools.
> 
> Hmm... I thought it was like any other integral types, no?
> 

Boolean bit-fields are indeed valid.  Usual semantics for objects of type
_Bool apply.

C99 6.7.2.1 Structure and union specifiers

4   A bit-field shall have a type that is a qualified or unqualified
    version of _Bool, signed int, unsigned int, or some other
    implementation-defined type.

-- 
Nick Bowler, Elliptic Semiconductor (http://www.ellipticsemi.com/)

