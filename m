Return-Path: <linux-kernel-owner+w=401wt.eu-S1758664AbYILXQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758664AbYILXQc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 19:16:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756976AbYILXQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 19:16:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44532 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756817AbYILXQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 19:16:23 -0400
Message-ID: <48CAF822.5030903@zytor.com>
Date: Fri, 12 Sep 2008 16:15:46 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: linux@sandersweb.net
CC: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: nops in virtual pc x86
References: <200809121711.48558.linux@sandersweb.net> <alpine.LFD.1.10.0809121501390.3337@nehalem.linux-foundation.org> <200809121905.23724.linux@sandersweb.net>
In-Reply-To: <200809121905.23724.linux@sandersweb.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Sanders wrote:
> And even stranger, the same program won't run on the host OS because of data 
> execution prevention.

Not strange at all.  It means Virtual PC just doesn't handle the NX bit 
right.

> I reported the problem to Microsoft, they say they are aware of it and working 
> on a resolution.

Virtual Server 2007 fixed some of these issues (over VS 2005, which had 
the same problems.)

	-hpa
