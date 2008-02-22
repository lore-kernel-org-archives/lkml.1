Return-Path: <linux-kernel-owner+w=401wt.eu-S935401AbYBVAWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935401AbYBVAWc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 19:22:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759097AbYBVAWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 19:22:23 -0500
Received: from ag-out-0708.google.com ([72.14.246.246]:36149 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244AbYBVAWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 19:22:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=u1GgxATsuOWmqcig48mo+CpyR6s8KM/D/djLiwB89AeTifLOnKo0vVQ7Ahr7aFfpuplldjL6a6O2nZd/5l6Lu5FQEQlHujtFwQRFVWDwJDEyuy3Aayq4RgrOmAu72pgPIWic0xuxoU4PKWcfzZ89FFIK6Q8wFcxL47mY0Req63k=
Subject: Re: linux-next: first tree
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Frank Seidel <fseidel@suse.de>, Stephen Rothwell <sfr@canb.auug.org.au>,
       Andy Whitcroft <apw@shadowen.org>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <47BE137F.3030704@oracle.com>
References: <20080215003537.8911ce35.sfr@canb.auug.org.au>
	 <20080214160231.GC10713@shadowen.org>
	 <20080221012332.dc1948ac.sfr@canb.auug.org.au>
	 <20080220084747.77553451.randy.dunlap@oracle.com>
	 <47BE1225.7030808@suse.de>  <47BE137F.3030704@oracle.com>
Content-Type: text/plain
Date: Thu, 21 Feb 2008 16:22:36 -0800
Message-Id: <1203639756.20345.77.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-02-21 at 16:12 -0800, Randy Dunlap wrote:
> Frank Seidel wrote:
> > Randy Dunlap wrote:
> >> I'd like to see tarballs too, please...
> > 
> > Hi, i'll provide tars of the current linux-next tree reachable
> > via my http://linux-next.f-seidel.de wiki ("Tar Downloads").
> > Is that what you were looking for?
> 
> Looks close.  It needs to be scriptable (not just a dynamically generated
> link) and have predictable names.  As long as those are true, then it
> should be great.
> 



// add the next git repo as a tracked remote
git remote add next git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git
// fetch any objects you don't have
// run this whenever you want to check for more objects
git remote update
// produce a tarball of the tree tagged next-20080220
git archive --format=tar next-20080220 > next-20080220.tar

Cheers,

Harvey



