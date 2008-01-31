Return-Path: <linux-kernel-owner+w=401wt.eu-S934403AbYAaWoo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934403AbYAaWoo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 17:44:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762213AbYAaWoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 17:44:37 -0500
Received: from pat.uio.no ([129.240.10.15]:51553 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762199AbYAaWoh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 17:44:37 -0500
Subject: Re: degrading performance (NFS v.3 client)
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: r31dmaeu@pc0312b.rz.unibw-muenchen.de
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <47A1E4AB.2010504@pc0312a.rz.unibw-muenchen.de>
References: <47A1E4AB.2010504@pc0312a.rz.unibw-muenchen.de>
Content-Type: text/plain
Date: Thu, 31 Jan 2008 17:44:33 -0500
Message-Id: <1201819473.11897.34.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-ClamAV-Virus: No
X-UiO-Spam-info: not spam, SpamAssassin (score=0.0, required=5.0, autolearn=disabled, none)
X-UiO-Scanned: 49081716DD7EF73F8518933F0F9A439B42E5889A
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 578 total 6613122 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-01-31 at 16:09 +0100, Claude Frantz wrote:
> Hello !
> 
> Please allow me to submit to you a question related to a system which
> is a NFS v3 client for a Netapp server. The home directories are
> NFS attached. The following behaviour occurs sometimes. The system 
> becomes very slow. The load average is increasing but the most
> interesting observation is the increase of the %iowait. After
> reboot the system is running well for many days, then the problem 
> occurs again.
> 
> Any idea ?

Hi,

Have you tried analysing the NFS performances using Chuck's nfs-iostat
utility? You can pick up a copy at
    http://oss.oracle.com/~cel/linux-2.6/2.6.24/

Try looking both at

	nfs-iostat 10 --page
and
	nfs-iostat 10 --attr

to see what the differences are between the 'fast' and 'slow' cases...

Cheers
  Trond

