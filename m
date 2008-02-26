Return-Path: <linux-kernel-owner+w=401wt.eu-S1762255AbYBZJST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762255AbYBZJST (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 04:18:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762119AbYBZJRm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 04:17:42 -0500
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:25190 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1762104AbYBZJRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 04:17:38 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=gCSWPFD9Z3fUUGw0XTIrnL4tMLs8nbtQ3WXSO3rCuWtCO/uXqvqHhSL6yUIXWOs7cpJSnkCT2YkPUAMXG2PZ+LID3egOD8pzfQUNwifbWupIoXRqdq1jfjIDsTSf6m1/gdTNFjesTepoVPmolFWb2RiLYiNOH52q7SZ5HcUbxDs=  ;
X-YMail-OSG: 5uajkz4VM1n3gNoE4172R9Q0vvxckGY3KSP3vAQSvpujU74KIaxt6VqnPfJaOcfs2.F9cQe3LA--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: Re: [patch 2.6.25-rc2-git 1/2] atmel_tc library
Date: Tue, 26 Feb 2008 01:17:34 -0800
User-Agent: KMail/1.9.6
Cc: nicolas.ferre@rfo.atmel.com, linux@maxim.org.za,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <200802221723.24003.david-b@pacbell.net> <20080225180644.78CA31E564F@adsl-69-226-248-13.dsl.pltn13.pacbell.net> <20080226100813.0f55127b@hskinnemoen.norway.atmel.com>
In-Reply-To: <20080226100813.0f55127b@hskinnemoen.norway.atmel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200802260117.35062.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 February 2008, Haavard Skinnemoen wrote:
> Ok. Let's drop the clock references...
> 
> > >     and it will always need a pointer through which to access the
> > > registers, so the mid-layer might as well do those things.
> > 
> > True about doing the ioremap.
> 
> ...and keep the regs pointer, and possibly add the iomem resource.
> 
> Ok?

I'd be OK with clocks *and* irqs, but don't feel religious at all.


> Btw, I'm not saying that you're the one who has to make these changes.
> Once we agree, I can send a patch to do the things we agreed on.

I'll ask you to do that then, yes.

- Dave



