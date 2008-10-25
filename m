Return-Path: <linux-kernel-owner+w=401wt.eu-S1754423AbYJYSxP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754423AbYJYSxP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 14:53:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751581AbYJYSw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 14:52:59 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:56262 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbYJYSw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 14:52:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=w83qCbIlLk0/EMnaA/akYseWDplr9QRXMKblPa18fcwwniUIATto+fq1zRN6uhy1dY
         TWIe1seGDD3XbFfYWlViscx4j3wA8xFly2dL7/5bQTWNyJaEGh0vUJc7/f1ZHcvrW+5r
         yN/IzURubXP+oJb3wLWqC3gP+uo9HHHtmj6lg=
Subject: Re: [PATCH] ubifs: endian handling fixes and annotations
From: Harvey Harrison <harvey.harrison@gmail.com>
To: dedekind@infradead.org
Cc: Adrian Hunter <ext-adrian.hunter@nokia.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1224932256.4466.135.camel@sauron>
References: <1224870777.5966.3.camel@brick>
	 <1224932256.4466.135.camel@sauron>
Content-Type: text/plain
Date: Sat, 25 Oct 2008 11:52:55 -0700
Message-Id: <1224960775.5784.13.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-10-25 at 13:57 +0300, Artem Bityutskiy wrote:
> Harvey,
> 
> On Fri, 2008-10-24 at 10:52 -0700, Harvey Harrison wrote:
> > Noticed by sparse:
> > fs/ubifs/file.c:75:2: warning: restricted __le64 degrades to integer
> > fs/ubifs/file.c:629:4: warning: restricted __le64 degrades to integer
> > fs/ubifs/dir.c:431:3: warning: restricted __le64 degrades to integer
> > 
> > This should be checked to ensure the ubifs_assert is working as
> > intended, I've done the suggested annotation in this patch.
> > 
> > fs/ubifs/sb.c:298:6: warning: incorrect type in assignment (different base types)
> > fs/ubifs/sb.c:298:6:    expected int [signed] [assigned] tmp
> > fs/ubifs/sb.c:298:6:    got restricted __le64 [usertype] <noident>
> > fs/ubifs/sb.c:299:19: warning: incorrect type in assignment (different base types)
> > fs/ubifs/sb.c:299:19:    expected restricted __le64 [usertype] atime_sec
> > fs/ubifs/sb.c:299:19:    got int [signed] [assigned] tmp
> > fs/ubifs/sb.c:300:19: warning: incorrect type in assignment (different base types)
> > fs/ubifs/sb.c:300:19:    expected restricted __le64 [usertype] ctime_sec
> > fs/ubifs/sb.c:300:19:    got int [signed] [assigned] tmp
> > fs/ubifs/sb.c:301:19: warning: incorrect type in assignment (different base types)
> > fs/ubifs/sb.c:301:19:    expected restricted __le64 [usertype] mtime_sec
> > fs/ubifs/sb.c:301:19:    got int [signed] [assigned] tmp
> 
> ... snip ...
> 
> thanks for the patch. It's shame we did not fix this ourselves. We did
> run sparse before submitting UBIFS and did not see these warnings.
> Probably sparse has been improved recently. Anyway, thank you, I'll look
> closer at your patch and apply it to ubifs-2.6.git.
> 

Run sparse with -D__CHECK_ENDIAN__ to see these warnings.

Harvey



