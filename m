Return-Path: <linux-kernel-owner+w=401wt.eu-S1753884AbYJZNYN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884AbYJZNYN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 09:24:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753404AbYJZNX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 09:23:58 -0400
Received: from smtp.nokia.com ([192.100.105.134]:48281 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387AbYJZNX5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 09:23:57 -0400
Subject: Re: [PATCH] ubifs: endian handling fixes and annotations
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Adrian Hunter <ext-adrian.hunter@nokia.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1224960775.5784.13.camel@brick>
References: <1224870777.5966.3.camel@brick>
	 <1224932256.4466.135.camel@sauron>  <1224960775.5784.13.camel@brick>
Content-Type: text/plain; charset=utf-8
Date: Sun, 26 Oct 2008 15:22:33 +0200
Message-Id: <1225027353.4466.144.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 26 Oct 2008 13:23:46.0245 (UTC) FILETIME=[130EFF50:01C9376E]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-10-25 at 11:52 -0700, Harvey Harrison wrote:
> > > fs/ubifs/sb.c:300:19: warning: incorrect type in assignment (different base types)
> > > fs/ubifs/sb.c:300:19:    expected restricted __le64 [usertype] ctime_sec
> > > fs/ubifs/sb.c:300:19:    got int [signed] [assigned] tmp
> > > fs/ubifs/sb.c:301:19: warning: incorrect type in assignment (different base types)
> > > fs/ubifs/sb.c:301:19:    expected restricted __le64 [usertype] mtime_sec
> > > fs/ubifs/sb.c:301:19:    got int [signed] [assigned] tmp
> > 
> > ... snip ...
> > 
> > thanks for the patch. It's shame we did not fix this ourselves. We did
> > run sparse before submitting UBIFS and did not see these warnings.
> > Probably sparse has been improved recently. Anyway, thank you, I'll look
> > closer at your patch and apply it to ubifs-2.6.git.
> > 
> 
> Run sparse with -D__CHECK_ENDIAN__ to see these warnings.

Any idea why this is not default?

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

