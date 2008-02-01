Return-Path: <linux-kernel-owner+w=401wt.eu-S1760152AbYBAVvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760152AbYBAVvX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 16:51:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754407AbYBAVvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 16:51:16 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:51964 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399AbYBAVvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 16:51:15 -0500
Date: Fri, 1 Feb 2008 22:51:14 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Andi Kleen <ak@suse.de>
cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       linux arch <linux-arch@vger.kernel.org>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Are Section mismatches out of control?
In-Reply-To: <200802011210.52655.ak@suse.de>
Message-ID: <Pine.LNX.4.64.0802012250251.18790@fbirervta.pbzchgretzou.qr>
References: <20080201104718.GA11717@uranus.ravnborg.org> <200802011210.52655.ak@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 1 2008 12:10, Andi Kleen wrote:
>On Friday 01 February 2008 11:47:18 Sam Ravnborg wrote:
>> James said in a related posting that the Section mismatch
>> warnings were getting out of control.
>
>My question is: where are crashes? If the sections were
>really in such bad shape and since we poison (and sometimes
>even unmap) init after boot we should in theory see a lot 
>of oops reports from this if there were really accesses to
>them after boot.
>
>Where are they?

Perhaps still in RAM? Explicitly zero the area after unmapping,
maybe something happens.
