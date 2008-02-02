Return-Path: <linux-kernel-owner+w=401wt.eu-S1763882AbYBBEIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763882AbYBBEIv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 23:08:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759535AbYBBEIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 23:08:44 -0500
Received: from one.firstfloor.org ([213.235.205.2]:41030 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753697AbYBBEIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 23:08:44 -0500
Date: Sat, 2 Feb 2008 05:43:18 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Jike Song <albcamus@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, Rijndael Cosque <rijcos@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: What's the status of x2APIC support in Linux kernel?
Message-ID: <20080202044318.GC12644@one.firstfloor.org>
References: <26e10850802010043m7375a110t6428d637ed1872bc@mail.gmail.com> <df9815e70802010053n4565397dofd847373df522e5c@mail.gmail.com> <p73fxwc50s5.fsf@bingen.suse.de> <df9815e70802011855p29c10787lcee23bc9fab181d4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <df9815e70802011855p29c10787lcee23bc9fab181d4@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Section 5 and section 9.5 describe 'I/OxAPIC'. I'm not sure if it is
> already supported by Linux, I guess it is not.

I'm not sure what the point of your questions is.  Do you want to 
do something concrete or are you just interested in random buzzwords?

Anyways as far as I know Linux supports the IO APICs implemented in all
x86 chipsets fully. That is it doesn't use every possible feature they have,
but I'm not aware of any particular limitation caused by Linux
not supporting some IO APIC feature.

The reason for the local x/APIC was that the original non x APIC did not support
more than 8 logical CPUs being active in the system. Presumably IO xAPIC 
refers to the IO APIC without this limitation too.

-Andi
