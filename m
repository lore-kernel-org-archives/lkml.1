Return-Path: <linux-kernel-owner+w=401wt.eu-S1756745AbXEXJRX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756745AbXEXJRX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 05:17:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754838AbXEXJRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 05:17:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:51803 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754523AbXEXJRK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 05:17:10 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs, Novell
To: James Morris <jmorris@namei.org>
Subject: Re: [AppArmor 01/41] Pass struct vfsmount to the inode_create LSM hook
Date: Thu, 24 May 2007 11:16:58 +0200
User-Agent: KMail/1.9.5
Cc: Al Viro <viro@ftp.linux.org.uk>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chrisw@sous-sol.org,
       Tony Jones <tonyj@suse.de>
References: <20070412090809.917795000@suse.de> <200705232106.28260.agruen@suse.de> <Line.LNX.4.64.0705232109030.3178@d.namei>
In-Reply-To: <Line.LNX.4.64.0705232109030.3178@d.namei>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200705241116.58851.agruen@suse.de>
X-Length: 3612
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 May 2007 03:28, James Morris wrote:
> On Wed, 23 May 2007, Andreas Gruenbacher wrote:
> > This is backwards from what AppArmor does. The policy defines which paths
> > may be accessed; all paths not explicitly listed are denied. If files are
> > mounted at multiple locations, then the policy may allow access to some
> > locations but not to others. That's not a hole.
>
> I don't know what else you'd call it.

AppArmor doesn't label files; it's a different model from SELinux. Its policy 
defines which processes may access which paths. Even if for some reson the 
same files were visible elsewhere, the policy wouldn't cover those other 
paths, and so accessing them would be denied. So again, that's not a security 
hole.

> Would you mind providing some concrete examples of how such a model would
> be useful?

The model is explained, with examples, in the technical documentation at 
http://forgeftp.novell.com//apparmor/LKML_Submission-May_07/.

Thanks,
Andreas
