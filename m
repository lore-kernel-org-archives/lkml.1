Return-Path: <linux-kernel-owner+w=401wt.eu-S1755525AbYHRSWI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525AbYHRSWI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 14:22:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753611AbYHRSVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 14:21:52 -0400
Received: from tamago.serverit.net ([91.189.209.155]:50120 "EHLO
	mail.hosting2.serverit.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753387AbYHRSVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 14:21:51 -0400
X-Greylist: delayed 2663 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Aug 2008 14:21:51 EDT
Date: Mon, 18 Aug 2008 20:37:12 +0300 (EEST)
From: Szabolcs Szakacsits <szaka@ntfs-3g.com>
X-X-Sender: szaka@tamago.serverit.net
To: Chris Mason <chris.mason@oracle.com>
cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: Btrfs v0.16 released
In-Reply-To: <1219067529.2137.1.camel@think.oraclecorp.com>
Message-ID: <Pine.LNX.4.62.0808181931220.32726@tamago.serverit.net>
References: <1217962876.15342.33.camel@think.oraclecorp.com> 
 <1218100464.8625.9.camel@twins>  <1218105597.15342.189.camel@think.oraclecorp.com>
  <877ias66v4.fsf@basil.nowhere.org>  <1218221293.15342.263.camel@think.oraclecorp.com>
  <1218747656.15342.439.camel@think.oraclecorp.com>  <20080814211756.GC13814@one.firstfloor.org>
  <1218763554.15342.460.camel@think.oraclecorp.com>  <20080815013934.GE19125@one.firstfloor.org>
  <1218805256.15342.484.camel@think.oraclecorp.com>  <Pine.LNX.4.61.0808162215320.4532@dhcppc2>
 <1219067529.2137.1.camel@think.oraclecorp.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 18 Aug 2008, Chris Mason wrote:
> On Sat, 2008-08-16 at 22:26 +0300, Szabolcs Szakacsits wrote:
> > 
> > We tried compilebench (-i 30 -r 0) just for fun using kernel 2.6.26, 
> > freshly formatted partition, with defaults. Results:
> > 
> >               MB/s    Runtime (s)
> >              -----    -----------
> >   ext3       13.24        877
> >   btrfs      12.33        793
> 
> Thanks for running things.
> 
> The code in the btrfs-unstable tree has all my performance fixes.
> You'll need it to get good results.  

The numbers are indeed much better:

                        MB/s    Runtime (s)
                       -----    -----------
   btrfs-unstable      17.09        572

The disk is capable of 40+ MB/s however the test partition was one of the 
last ones and as I figured it out now, it can do only 26 MB/sec. Btrfs bulk 
write easily sustains it. The write speed was 21 MB/s during the benchmark, 
so btrfs is the closest to the possible best write speed in the test 
environment.

	Szaka

--
NTFS-3G:  http://ntfs-3g.org

