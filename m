Return-Path: <linux-kernel-owner+w=401wt.eu-S1755564AbYJZSoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564AbYJZSoy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 14:44:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752751AbYJZSoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 14:44:46 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:65522 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101AbYJZSop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 14:44:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=WBssuNQPy+cf9EO7j3Og6BponO2WfaEzWhcug5kvthu3iynM+BsFgd9XplO3Pj2nwY
         E5NMsZTKoTI6Pfnm37XbcpemdAMJ664Sl3E/BQwJnO2oiFtXb0ot1MkQFqmcokLiRunn
         XmWp16bhag2oRDr+0qGpzDc2jGZ0MODFST92o=
Subject: Re: [PATCH] ubifs: endian handling fixes and annotations
From: Harvey Harrison <harvey.harrison@gmail.com>
To: dedekind@infradead.org
Cc: Adrian Hunter <ext-adrian.hunter@nokia.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1225027353.4466.144.camel@sauron>
References: <1224870777.5966.3.camel@brick>
	 <1224932256.4466.135.camel@sauron>  <1224960775.5784.13.camel@brick>
	 <1225027353.4466.144.camel@sauron>
Content-Type: text/plain
Date: Sun, 26 Oct 2008 11:44:42 -0700
Message-Id: <1225046682.10060.1.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-10-26 at 15:22 +0200, Artem Bityutskiy wrote:
> On Sat, 2008-10-25 at 11:52 -0700, Harvey Harrison wrote:
> > > > fs/ubifs/sb.c:300:19: warning: incorrect type in assignment (different base types)
> > > > fs/ubifs/sb.c:300:19:    expected restricted __le64 [usertype] ctime_sec
> > > > fs/ubifs/sb.c:300:19:    got int [signed] [assigned] tmp
> > > > fs/ubifs/sb.c:301:19: warning: incorrect type in assignment (different base types)
> > > > fs/ubifs/sb.c:301:19:    expected restricted __le64 [usertype] mtime_sec
> > > > fs/ubifs/sb.c:301:19:    got int [signed] [assigned] tmp
> > > 
> > > ... snip ...
> > > 
> > > thanks for the patch. It's shame we did not fix this ourselves. We did
> > > run sparse before submitting UBIFS and did not see these warnings.
> > > Probably sparse has been improved recently. Anyway, thank you, I'll look
> > > closer at your patch and apply it to ubifs-2.6.git.
> > > 
> > 
> > Run sparse with -D__CHECK_ENDIAN__ to see these warnings.
> 
> Any idea why this is not default?
> 

Currently the build gets a bit verbose with this turned on, I've been
working to get the noise down a bit, but perhaps still a ways off from
turning this on.

Harvey

