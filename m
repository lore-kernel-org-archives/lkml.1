Return-Path: <linux-kernel-owner+w=401wt.eu-S1757585AbZJBUIa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757585AbZJBUIa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 16:08:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757250AbZJBUI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 16:08:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52350 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756438AbZJBUI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 16:08:29 -0400
Message-ID: <4AC65CC9.4000105@zytor.com>
Date: Fri, 02 Oct 2009 13:04:25 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@tglx.de, torvalds@linux-foundation.org
Subject: Re: [PATCH] x86: Use __builtin_memset and __builtin_memcpy for memset/memcpy
References: <20090928113433.5e9b8ea7@infradead.org> <87bpkpbo3t.fsf@basil.nowhere.org>
In-Reply-To: <87bpkpbo3t.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2009 12:19 PM, Andi Kleen wrote:
> 
> I tried this some time ago, but it it generates bad code on some 
> gcc 3 versions.
> 
> You really need to test such kind of changes on a wide variety
> of compilers, not assuming everyone uses the same version as you.
> 

The version that went in is for gcc 4 only.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

