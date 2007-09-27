Return-Path: <linux-kernel-owner+w=401wt.eu-S1753726AbXI0QJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726AbXI0QJ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 12:09:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755563AbXI0QJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 12:09:49 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:46517 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752151AbXI0QJs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 12:09:48 -0400
X-Greylist: delayed 1786 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Sep 2007 12:09:48 EDT
Date: Thu, 27 Sep 2007 18:39:59 +0300 (EEST)
From: Timo Jantunen <jeti@iki.fi>
To: Francois Romieu <romieu@fr.zoreil.com>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: commit 6dccd16b7c2703e8bbf8bca62b5cf248332afbe2 kills r8169 send
 performance
In-Reply-To: <20070926215738.GA6443@electric-eye.fr.zoreil.com>
Message-ID: <Pine.LNX.4.64.0709271832270.5849@limbo>
References: <Pine.LNX.4.64.0709261853110.5869@limbo>
 <20070926170718.GA4870@electric-eye.fr.zoreil.com> <Pine.LNX.4.64.0709262137440.5856@limbo>
 <20070926215738.GA6443@electric-eye.fr.zoreil.com>
MIME-Version: 1.0
Content-Type: MULTIPART/Mixed; BOUNDARY="ikeVEW9yuYc//A+q"
Content-ID: <Pine.LNX.4.64.0709271832271.5849@limbo>
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--ikeVEW9yuYc//A+q
Content-Type: TEXT/PLAIN; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT
Content-ID: <Pine.LNX.4.64.0709271832272.5849@limbo>
Content-Disposition: INLINE

On Wed, 26 Sep 2007, Francois Romieu wrote:

> Apply and try each patch of the attached tarball on top of 2.6.23-git
> until the behavior changes (assuming it does).
> 
> Patch #000n applies on top of patch #000(n - 1).

I tested the series on top of -rc8 and 0005 did the trick. And if I use 
0005 only, I can get 93MB/s send and 97MB/s receive, so there is a nice 
increase on send too since .22!


iperf numbers (send/receive):

revert.0001:[  4]  0.0-10.1 sec    234 MBytes    194 Mbits/sec
revert.0001:[  5]  0.0-10.0 sec    445 MBytes    373 Mbits/sec

revert.0002:[  5]  0.0-10.0 sec    325 MBytes    272 Mbits/sec
revert.0002:[  4]  0.0-10.1 sec    969 MBytes    802 Mbits/sec

revert.0003:[  4]  0.0-10.1 sec    328 MBytes    272 Mbits/sec
revert.0003:[  5]  0.0-10.0 sec    742 MBytes    622 Mbits/sec

revert.0004:[  4]  0.0-10.2 sec    329 MBytes    271 Mbits/sec
revert.0004:[  5]  0.0-10.0 sec    759 MBytes    637 Mbits/sec

revert.0005:[  4]  0.0-10.1 sec    829 MBytes    691 Mbits/sec
revert.0005:[  5]  0.0-10.0 sec    772 MBytes    647 Mbits/sec

revert.0005-only:[  5]  0.0-10.0 sec    933 MBytes    780 Mbits/sec
revert.0005-only:[  4]  0.0-10.1 sec    970 MBytes    806 Mbits/sec



//T


> Good night.


// /
....................................Timo Jantunen  ......................
       ZZZ      (Used to represent :Kuunsäde 8 A 28: Email: jeti@iki.fi :
the  sound of  a person  snoring.) :FIN-02210 Espoo: http://iki.fi/jeti :
Webster's  Encyclopedic Unabridged :Finland        : GSM+358-40-5763131 :
Dictionary of the English Language :...............:....................:
--ikeVEW9yuYc//A+q--
