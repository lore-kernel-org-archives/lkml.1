Return-Path: <linux-kernel-owner+w=401wt.eu-S1755533AbXJJC5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533AbXJJC5X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 22:57:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752782AbXJJC5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 22:57:14 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:24642 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751926AbXJJC5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 22:57:14 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=fUCCTXrv9ao15E4xQOiNNTfCNEYV43sLItuAMZ2mrrSW07TiK2i6XhdGvRrfkCVy/42pf7G4zbbH6Xj/gaJASvVXK5qsCO7ylRGo3u+y03YAZZp0Dhccpuajld35JhQjOknLj+47rajncuCIL7iJMHas+58FmcDVfuJE7GWWnA8=  ;
X-YMail-OSG: 9u_pTwcVM1kBulPGEzRYvVCRS91tE8aF04TXkJ_.FwAcgy1pW5VnQQA8q0s7Vb9oIWg_Hs5YJw--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Michael Stiller <ms@2scale.net>
Subject: Re: howto boost write(2) performance?
Date: Tue, 9 Oct 2007 20:25:34 +1000
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <1191937817.3641.9.camel@blackberry>
In-Reply-To: <1191937817.3641.9.camel@blackberry>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710092025.34436.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 October 2007 23:50, Michael Stiller wrote:
> Hi list,
>
> i'm developing an application (in C) which needs to write about
> 1Gbit/s (125Mb/s) to a disk array attached via U320 SCSI.
> It runs on Dual Core 2 Xeons @2Ghz utilizing kernel 2.6.22.7.
>
> I buffer the data in (currently 4) 400Mb buffers and use write(2) in a
> dedicated thread to write them to the raw disk (no fs).
>
> The write(2) performance is not good enough, the writer threads take to
> much time, and i ask you for ideas, howto to boost the write
> performance.

The kernel really cannot sustain 125MB/s? I assume the disk
array is capable?

Where is the bottleneck? Does it keep all disks busy, or are
the CPUs overloaded?
