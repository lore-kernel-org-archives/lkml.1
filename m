Return-Path: <linux-kernel-owner+w=401wt.eu-S1757389AbXKFL22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757389AbXKFL22 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 06:28:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754143AbXKFL2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 06:28:19 -0500
Received: from [212.12.190.170] ([212.12.190.170]:54284 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752933AbXKFL2S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 06:28:18 -0500
From: Al Boldi <a1426z@gawab.com>
To: linux-fsdevel@vger.kernel.org
Subject: Re: Massive slowdown when re-querying large nfs dir
Date: Tue, 6 Nov 2007 14:28:11 +0300
User-Agent: KMail/1.5
Cc: linux-kernel@vger.kernel.org
References: <200711050758.38090.a1426z@gawab.com>
In-Reply-To: <200711050758.38090.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711061428.11453.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Boldi wrote:
> There is a massive (3-18x) slowdown when re-querying a large nfs dir (2k+
> entries) using a simple ls -l.
>
> On 2.6.23 client and server running userland rpc.nfs.V2:
> first  try: time -p ls -l <2k+ entry dir>  in ~2.5sec
> more tries: time -p ls -l <2k+ entry dir>  in ~8sec
>
> first  try: time -p ls -l <5k+ entry dir>  in ~9sec
> more tries: time -p ls -l <5k+ entry dir>  in ~180sec
>
> On 2.6.23 client and 2.4.31 server running userland rpc.nfs.V2:
> first  try: time -p ls -l <2k+ entry dir>  in ~2.5sec
> more tries: time -p ls -l <2k+ entry dir>  in ~7sec
>
> first  try: time -p ls -l <5k+ entry dir>  in ~8sec
> more tries: time -p ls -l <5k+ entry dir>  in ~43sec
>
> Remounting the nfs-dir on the client resets the problem.
>
> Any ideas?

Ok, I played some more with this, and it turns out that nfsV3 is a lot 
faster.  But, this does not explain why the 2.4.31 kernel is still over 
4-times faster than 2.6.23.

Can anybody explain what's going on?


Thanks!

--
Al

