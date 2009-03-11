Return-Path: <linux-kernel-owner+w=401wt.eu-S1753846AbZCKSD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846AbZCKSD7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 14:03:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751995AbZCKSDu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 14:03:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37815 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbZCKSDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 14:03:50 -0400
Message-ID: <49B7FCA8.80004@zytor.com>
Date: Wed, 11 Mar 2009 11:02:16 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ian Campbell <ijc@hellion.org.uk>
CC: Woody Suwalski <woodys@xandros.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: x86: removing zImage support?
References: <49B703D4.1000008@zytor.com> <49B7C729.5080301@xandros.com>	 <49B7EEEA.3080203@zytor.com> <1236793176.12283.255.camel@zakaz.uk.xensource.com>
In-Reply-To: <1236793176.12283.255.camel@zakaz.uk.xensource.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Campbell wrote:
> 
> Is there any point in just making bzImage==zImage for x86?
> 

Not really.  The *last* thing we want is to make people start using the
name zImage, and then getting confused when an older kernel doesn't build.

> I lost count of the number of times I've explained that bzImage has
> nothing to do with bzip...

Just to be extra confusing, in -tip there is code to compress it with
bzip2 ;)

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

