Return-Path: <linux-kernel-owner+w=401wt.eu-S1753967AbZAZRv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967AbZAZRv0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 12:51:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752335AbZAZRvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 12:51:17 -0500
Received: from mx2.redhat.com ([66.187.237.31]:58646 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752029AbZAZRvP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 12:51:15 -0500
Subject: Re: [RT] [RFC] simple SMI detector
From: Jon Masters <jcm@redhat.com>
To: Mike Kravetz <kravetz@us.ibm.com>
Cc: linux-rt-users@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       williams <williams@redhat.com>,
       "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>
In-Reply-To: <20090125225205.GA3783@monkey.beaverton.ibm.com>
References: <1232751312.3990.59.camel@perihelion.bos.jonmasters.org>
	 <20090125225205.GA3783@monkey.beaverton.ibm.com>
Content-Type: text/plain
Organization: Red Hat, Inc.
Date: Mon, 26 Jan 2009 12:51:12 -0500
Message-Id: <1232992272.19862.3.camel@londonpacket.bos.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-01-25 at 14:52 -0800, Mike Kravetz wrote:

> Any reason why you could not do SMI detection in user level code running
> at the highest RT priority?

Yeah. I had some suggestions about that already...the problem with that
is that you can't know whether measured latencies are due to SMIs /or/
other kernel latencies - maybe there's a bug or other problem? I really
want to be able to say to vendors "nope, it's definitely your problem".

So I think what'll end up happening is a user process for ease of
deployment but something like smi_detector for advanced diagnostics. And
then I just hope others will write tools like the one IBM already has
that will turn off extraneous SMI generation :)

Jon.


