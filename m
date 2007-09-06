Return-Path: <linux-kernel-owner+w=401wt.eu-S932860AbXIFXWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932860AbXIFXWW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 19:22:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932578AbXIFXWO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 19:22:14 -0400
Received: from pat.uio.no ([129.240.10.15]:40145 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932593AbXIFXWN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 19:22:13 -0400
Subject: Re: NFS4 authentification / fsuid
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Satyam Sharma <satyam@infradead.org>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20070906151118.GB28565@fieldses.org>
References: <Pine.LNX.4.64.0708301610290.24730@fbirervta.pbzchgretzou.qr>
	 <1188484155.6755.38.camel@heimdal.trondhjem.org>
	 <1188484337.6755.41.camel@heimdal.trondhjem.org>
	 <Pine.LNX.4.64.0708301640030.24730@fbirervta.pbzchgretzou.qr>
	 <1188486240.6755.51.camel@heimdal.trondhjem.org>
	 <20070830214431.GF10808@fieldses.org>
	 <alpine.LFD.0.999.0709061333410.3781@enigma.security.iitk.ac.in>
	 <alpine.LFD.0.999.0709061355350.3781@enigma.security.iitk.ac.in>
	 <20070906151118.GB28565@fieldses.org>
Content-Type: text/plain
Date: Fri, 07 Sep 2007 01:21:50 +0200
Message-Id: <1189120910.6672.30.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=0.0, required=12.0, autolearn=disabled, none)
X-UiO-Scanned: BDAFD61DF66B32C9CF6480FEA23A145743CBAED8
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 102 total 3719373 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-09-06 at 11:11 -0400, J. Bruce Fields wrote:
> On Thu, Sep 06, 2007 at 01:59:50PM +0530, Satyam Sharma wrote:
> > Oh and btw, note that we're talking of the (lack of) security of a
> > "running kernel" here -- because across reboots, there is /really/
> > *absolutely* no such thing as "kernelspace security" because the superuser
> > will simply switch the vmlinuz itself ...
> 
> Well, the machine could be booting from cdrom, and could live in a
> locked machine room.  Or people with root on a virtual host don't
> necessarily have the ability to replace the kernel for that host.

mount -t tmpfs none /my_tmpfs
cd /my_tmpfs
cp -a /bin bin
cp -p my_keylogging_pam_module.so lib
pivot_root . /old-root

to take another example....

