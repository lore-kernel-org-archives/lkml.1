Return-Path: <linux-kernel-owner+w=401wt.eu-S1755664AbZEVJjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664AbZEVJjm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 05:39:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751729AbZEVJjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 05:39:32 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:38780 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbZEVJjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 05:39:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=ZBvyW0wcOZ27zKSeUCUCpQJhk0BCMJ/7MLQILYpkGkFp4LGD2BI3WGKl/m55C5zt4G
         Co4lNjoHdYkGV/21EUe6yykFHALgLzePhF+37O4/aK/MWVfLKdiav9SthB1PEVUL/P7A
         hyj//6H+bvueOSL0FBdjrOOuSUP18758xJ+E8=
MIME-Version: 1.0
Reply-To: AdvandenBroek.nl@gmail.com
Date: Fri, 22 May 2009 11:39:31 +0200
Message-ID: <9f924d250905220239k1dc36aaeib3c2ec955267038a@mail.gmail.com>
Subject: PIPE_SIZE aspects
From: Ad van den Broek <advandenbroek.nl@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I searched the net regarding PIPE_SIZE aspects.
This is what I found:

* The constant PIPE_SIZE
establishes the number of bytes allocated for a pipe
(the size of the pipe buffer)

* The default of PIPE_SIZE (in Linux 2.4) is PAGE_SIZE.
* The default of PIPE_SIZE (in Linux 2.6) is 64K.

* PAGE_SIZE (in Linux 2.4) is CPU/hw depending,
  may not be changed and is 4K for x86.
* PAGE_SIZE (in Linux 2.6) is 64K.

* PIPE_SIZE can be changed in Linux 2.4,
  but it should be NOT larger than PAGE_SIZE
  or a patch should be implemented

 I found a patch (I believe the author is Julian Bradfield) at
 http://lse.sourceforge.net/pipe/2.4.9-pipe.patch
 and this patch is modified by Manfred Spraul which version can be found at
 http://linuxperf.sourceforge.net/patches/2.4.13-largepipe.patch
 It is tested with PIPE_SIZE from 1 upto 2,4,8 pages.
 and the result is at http://lse.sourceforge.net/pipe/pipe-report.txt


My questions:
 Is the above info correct ?
 Is the large pipe patch still correct for last 2.4.x versions ?
 Is such a patch also required/possible in Linux 2.6
 to allow PIPE_SIZE > PAGE_SIZE or is that different in 2.6 ?



-- 

With best regards,
Ad van den Broek
The Netherlands
