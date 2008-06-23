Return-Path: <linux-kernel-owner+w=401wt.eu-S1756074AbYFWD4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074AbYFWD4T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 23:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753077AbYFWD4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 23:56:12 -0400
Received: from smtp111.mail.mud.yahoo.com ([209.191.84.64]:37137 "HELO
	smtp111.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752854AbYFWD4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 23:56:12 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=c2u4lvZzt5k+Xzkb67wd7xvJPaLChQYqm2OdgsYcMd0lVvE4BjZnpPgsMwKG+UyWOq1ZSdUSAF4/GOMTtJfGceda5gAQuWFFAtUe4aUlJfc6TvNETl0C1wOD+ehV4WJwoOd/OhC9UiRmwScBft+u9cWwC3TZPuWcPJH55osZuO8=  ;
X-YMail-OSG: rGvUdcwVM1mnFzGjUdY6T0RPJjGmLhL0xEGfQ936qbc_rTzpLPOiNrNvckXIFD5.OV3n3BeyEexkHjTTo8P_Ap2ocy7Nc4M7cy8EB6myVaFgxHAc4pOwY9Zowmlr_O44Psc-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: "Ryan Hope" <rmh3093@gmail.com>
Subject: Re: [BUG] Lockless patches cause hardlock under heavy IO
Date: Mon, 23 Jun 2008 13:56:00 +1000
User-Agent: KMail/1.9.5
Cc: "Peter Zijlstra" <peterz@infradead.org>, linux-mm@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
References: <48f7fe350806181415l4eba61b3i1d206de03147575e@mail.gmail.com> <200806231229.42943.nickpiggin@yahoo.com.au> <48f7fe350806222051g15edcd98g6faecc4a23f727ab@mail.gmail.com>
In-Reply-To: <48f7fe350806222051g15edcd98g6faecc4a23f727ab@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806231356.01030.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 June 2008 13:51, Ryan Hope wrote:
> well i get the hardlock on -mm with out using reiser4, i am pretty
> sure is swap related

Oh you do, OK good, it would be nice if I were able to reproduce it here.

Any particular thing that triggers it? Preferably without running X or
any proprietary software (eg. if you run a make -j128 kernel compile or
something that forces a lot of swapping, does that lock up?).

What filesystem? Can you also attach your .config

No luck getting a backtrace out of the NMI watchdog?

Thanks,
Nick
