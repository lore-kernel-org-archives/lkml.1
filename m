Return-Path: <linux-kernel-owner+w=401wt.eu-S1762014AbZFPS41@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762014AbZFPS41 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 14:56:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761024AbZFPS4U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 14:56:20 -0400
Received: from stz-softwaretechnik.de ([217.160.223.211]:2005 "EHLO
	stlx01.stz-softwaretechnik.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751581AbZFPS4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 14:56:19 -0400
Date: Tue, 16 Jun 2009 20:56:00 +0200
From: Ralf Gross <rg@stz-softwaretechnik.com>
To: linux-kernel@vger.kernel.org
Subject: Re: io-scheduler tuning for better read/write ratio
Message-ID: <20090616185600.GC7043@p15145560.pureserver.info>
References: <20090616154342.GA7043@p15145560.pureserver.info> <4A37CB2A.6010209@davidnewall.com> <20090616184027.GB7043@p15145560.pureserver.info> <4A37E7DB.7030100@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A37E7DB.7030100@redhat.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Casey Dahlin schrieb:
> On 06/16/2009 02:40 PM, Ralf Gross wrote:
> > David Newall schrieb:
> >> Ralf Gross wrote:
> >>> write throughput is much higher than the read throughput (40 MB/s
> >>> read, 90 MB/s write).
> > 
> > Hm, but I get higher read throughput (160-200 MB/s) if I don't write
> > to the device at the same time.
> > 
> > Ralf
> 
> How specifically are you testing? It could depend a lot on the
> particular access patterns you're using to test.

I did the basic tests with tiobench. The real test is a test backup
(bacula) with 2 jobs that create 2 30 GB spool files on that device.
The jobs partially write to the device in parallel. Depending which
spool file reaches the 30 GB first, one starts reading from that file
and writing to tape, while to other is still spooling.

Ralf
