Return-Path: <linux-kernel-owner+w=401wt.eu-S1758097AbXHPErR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758097AbXHPErR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 00:47:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752633AbXHPErE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 00:47:04 -0400
Received: from smtp-out.google.com ([216.239.45.13]:12250 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060AbXHPErB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 00:47:01 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=RxNPc+1ZylFezGqqe0BEk78QcA5bBLl+2VktQ+Xyz/hblz6cKatCR/2IKGrVku2wd
	Y8LWOWoXtep0LKjdjjoLg==
Message-ID: <6599ad830708152146n7c617626pecec496bebc383cf@mail.gmail.com>
Date: Wed, 15 Aug 2007 21:46:39 -0700
From: "Paul Menage" <menage@google.com>
To: "Paul Jackson" <pj@sgi.com>
Subject: Re: [ckrm-tech] Regression in 2.6.23-rc2-mm2, mounting cpusets causes a hang
Cc: "Lee Schermerhorn" <Lee.Schermerhorn@hp.com>,
       ckrm-tech@lists.sourceforge.net, balbir@in.ibm.com,
       vatsa@linux.vnet.ibm.com, bob.picco@hp.com,
       linux-kernel@vger.kernel.org, mel@skynet.ie, nacc@us.ibm.com,
       akpm@linux-foundation.org, clameter@sgi.com,
       kamezawa.hiroyu@jp.fujitsu.com, serge@hallyn.com
In-Reply-To: <20070815092954.bfe7e86d.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070812152126.GA26239@linux.vnet.ibm.com>
	 <20070814180339.GA32553@vino.hallyn.com>
	 <1187115224.6281.40.camel@localhost>
	 <20070814192306.GB32553@vino.hallyn.com>
	 <20070814204951.GA2065@vino.hallyn.com>
	 <Pine.LNX.4.64.0708141427150.31693@schroedinger.engr.sgi.com>
	 <1187127685.6281.139.camel@localhost>
	 <Pine.LNX.4.64.0708141454110.32257@schroedinger.engr.sgi.com>
	 <1187185392.5422.13.camel@localhost>
	 <20070815092954.bfe7e86d.pj@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/15/07, Paul Jackson <pj@sgi.com> wrote:
> Lee wrote:
> > [altho' methinks CPUSET should select CONTAINERS rather than
> > depend on it...]
>
> Good point -- what do you think, Paul Menage?

That's how I made the configs originally; akpm asked me to invert the
dependencies to use "depends" rather than "select" due to some general
problems with using "select". I agree that "select" seems more
natural.

Paul
