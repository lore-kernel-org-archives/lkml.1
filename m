Return-Path: <linux-kernel-owner+w=401wt.eu-S938688AbXHIR0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938688AbXHIR0Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 13:26:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758932AbXHIR0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 13:26:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37000 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757232AbXHIR0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 13:26:06 -0400
Message-ID: <46BB4E26.6010007@zytor.com>
Date: Thu, 09 Aug 2007 10:25:58 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: huang ying <huang.ying.caritas@gmail.com>,
       Etienne Lorrain <etienne_lorrain@yahoo.fr>,
       linux-kernel@vger.kernel.org, ebiederm@xmission.com
Subject: Re: [PATCH 5/5] x86_64 EFI support -v3: EFI document
References: <183884.85434.qm@web26915.mail.ukl.yahoo.com> <200708091251.21726.ak@suse.de> <851fc09e0708090709s4f4fbbf9r91a7300a773f985a@mail.gmail.com> <200708091901.11146.ak@suse.de>
In-Reply-To: <200708091901.11146.ak@suse.de>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> 
> Ah i didn't realize this. Ok then kexec is also quite broken.
> Somehow this must have been missed this fundamental flaw when this code was 
> reviewed.
> 

It wasn't missed.  It was given the "there is no other way" defence, and
somehow that was considered sufficient.

Now, one could argue that kexec can just pass the boot_params from the
previous kernel boot, except there is no way to read them out, and so
it's not how it actually works.

	-hpa
