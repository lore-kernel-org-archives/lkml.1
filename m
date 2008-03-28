Return-Path: <linux-kernel-owner+w=401wt.eu-S1752865AbYC1Hot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865AbYC1Hot (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 03:44:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751688AbYC1Hol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 03:44:41 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:7054 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614AbYC1Hok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 03:44:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DPc3xwDJgXKBNko2+S9PGM4OvuvDrXpch03AwlbWoH3T4QuQA3l1NHHkqiJR6EneY6F3Lzdb5TrdxhoJr8XTZV2ONrOC/TvnAVs39f4QmbOkCkDPtiJurdFsp2JlUslIIAavjU8fuugFlERrN3FwGZja7PLU6fqo2Y2b5FfV1r4=
Message-ID: <e2e108260803280044o1bf41e5q8fd0b00a772b54a4@mail.gmail.com>
Date: Fri, 28 Mar 2008 08:44:37 +0100
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Bill Davidsen" <davidsen@tmr.com>
Subject: Re: RAID-1 performance under 2.4 and 2.6
Cc: "Chris Snook" <csnook@redhat.com>,
       "Emmanuel Florac" <eflorac@intellique.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <47EC173F.4050309@tmr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080325194306.4ac71ff2@galadriel.home>
	 <47E975F8.3000702@redhat.com>
	 <e2e108260803260015l5e8ba4f7n4fdbac771b13cbba@mail.gmail.com>
	 <47EC173F.4050309@tmr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2008 at 10:53 PM, Bill Davidsen <davidsen@tmr.com> wrote:
> Bart Van Assche wrote:
> > On Tue, Mar 25, 2008 at 11:00 PM, Chris Snook <csnook@redhat.com> wrote:
> >>  It means you shouldn't use dd as a benchmark.
> >
> > If you want to benchmark write speed, you should add
> > oflag=direct,dsync to the dd command line. For benchmarking read speed
> > you should specify iflag=direct. Or, even better, you can use xdd with
> > the flags -dio -processlock.
>
>  No, you want your benchmark to measure performance doing what the
>  application does. Do unless you have an application which has been
>  heavily Linux-ized you don't want to measure something unrelated to the
>  application requirements.

A basic fact I learned in science classes: if you measure something,
know very well what you measure and make sure your measurement is
repeatable. But it was some time ago I learned this. Maybe the whole
world changed since I learned that ?

Bart.
