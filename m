Return-Path: <linux-kernel-owner+w=401wt.eu-S1757950AbZDUBtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757950AbZDUBtQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 21:49:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752419AbZDUBs6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 21:48:58 -0400
Received: from mail-bw0-f163.google.com ([209.85.218.163]:43128 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753316AbZDUBs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 21:48:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=hfGU7y38BIrVSNmikVVQ/ZqBTrYvj8lgD9JqkFI7Wk3JhuQ8GBcFumeo+CYZgI/tfH
         sKxT1xJhjj+8DUczzxRcWwof2LEPmRK852QK49z5XqarkUSXpX69o7hPW4NKtk8t1N4p
         OzHxX7NN4IiV6XZaayGxX899wjIfx61HvSr+A=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v2 0/4] Add support for compiling with -ffunction-sections -fdata-sections
Date: Tue, 21 Apr 2009 03:49:41 +0200
User-Agent: KMail/1.8.2
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Tim Abbott <tabbott@mit.edu>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@mit.edu>, Waseem Daher <wdaher@mit.edu>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <andi@firstfloor.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Jeff Arnold <jbarnold@mit.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jon Masters <jonathan@jonmasters.org>
References: <1238973278-31735-1-git-send-email-tabbott@mit.edu> <alpine.LFD.2.00.0904201730590.2199@localhost.localdomain> <49ED2088.9090703@zytor.com>
In-Reply-To: <49ED2088.9090703@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904210349.41463.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 21 April 2009 03:25, H. Peter Anvin wrote:
> Linus Torvalds wrote:
> > 
> > Are there any advantages outside of the size things?
> > 
> > Do we end up packing data better? 
> > 
> > I'd like to have some more champions of this code, in other words.
> > 
> > I'd be ok with merging it, but I haven't really gotten a strong feeling 
> > that anybody is going to enable it or use it.
> > 
> 
> It may be a long haul to get people to actually use it, but there is a
> fairly major advantage near the end, and that is that we can structure
> the source code in a way that makes sense for reading it, rather than
> what will end up using what.
> 
> Assuming it does work correctly.

It's not like it's known to be broken. I use it all the time
for the stuff I build.
--
vda
