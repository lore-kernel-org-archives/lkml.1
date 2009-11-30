Return-Path: <linux-kernel-owner+w=401wt.eu-S1753555AbZK3IU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555AbZK3IU3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 03:20:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753456AbZK3IU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 03:20:27 -0500
Received: from mail-ew0-f215.google.com ([209.85.219.215]:37818 "EHLO
	mail-ew0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753486AbZK3IUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 03:20:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=rnJ6SDl0fiQtEPIY34DVBT5J9miJIZBz1jsOawWt36xfb+3vmmDnNzrpmMlxalW0SH
         FG936RmH2En8dxd+ma+XSTQOhHZRokjuFCyrF0Hle/1Suz8MU2IXcklAlHkK04soVM+S
         wiSNd/WfBf9f+4XSr3k9w99r7faxUlZ7Llwq0=
Date: Mon, 30 Nov 2009 10:20:32 +0200
From: Dan Carpenter <error27@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: host a git archive on an rsync server?
Message-ID: <20091130082032.GS10640@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Could someone do a git clone and put it on an rsync server for me?

I am in Africa and it is going to take some months before I get 
broadband.  The max bandwith I can currently buy at one time is 200MB.
It's not enough to clone of the kernel.  With git you can't download
200MB, disconnect and then download the remaining bits later, so
that's why I need rsync.

If I had the initial clone, I could pull in the changes every day
no problem.  

It costs $.05 USD per MB so maybe the best way to save bandwidth
is something like this:
git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
mv linux-2.6/.git linux-2.6.gitdir
tar cvvf linux-2.6.gitdir.tar linux-2.6.gitdir
bzip2 linux-2.6.gitdir.tar

I would be super grateful if anyone could do this.

thanks,
dan carpenter
