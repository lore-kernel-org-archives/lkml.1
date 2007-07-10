Return-Path: <linux-kernel-owner+w=401wt.eu-S1757975AbXGJP5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757975AbXGJP5T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 11:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754113AbXGJP5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 11:57:11 -0400
Received: from terminus.zytor.com ([192.83.249.54]:43744 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633AbXGJP5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 11:57:09 -0400
Message-ID: <4693AB6F.9030804@zytor.com>
Date: Tue, 10 Jul 2007 08:53:19 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Segher Boessenkool <segher@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [x86 setup 13/33] Header file to produce 16-bit code with gcc
References: <11840359321823-git-send-email-hpa@zytor.com> <11840373002601-git-send-email-hpa@zytor.com> <108510B6-B9BE-49D4-BDCA-E25CA20CB29B@kernel.crashing.org> <200707101721.58937.ak@suse.de> <4693AA56.9040109@zytor.com>
In-Reply-To: <4693AA56.9040109@zytor.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> 
> I'm a bit surprised about the claim w.r.t. -fno-unit-at-a-time (although
> I guess that is the default and one would thus typically not see this.)
>  Got any pointers why that would cause a global asm() to be scrambled
> around?
> 

Never mind.  It's quite right there in the gcc doc, and
-fno-unit-at-a-time is documented as the fix.

	-hpa
