Return-Path: <linux-kernel-owner+w=401wt.eu-S1758590AbXGJP1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758590AbXGJP1Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 11:27:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754022AbXGJP1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 11:27:18 -0400
Received: from mx1.suse.de ([195.135.220.2]:59096 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753915AbXGJP1R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 11:27:17 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [x86 setup 13/33] Header file to produce 16-bit code with gcc
Date: Tue, 10 Jul 2007 17:21:58 +0200
User-Agent: KMail/1.9.6
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, akpm@linux-foundation.org
References: <11840359321823-git-send-email-hpa@zytor.com> <11840373002601-git-send-email-hpa@zytor.com> <108510B6-B9BE-49D4-BDCA-E25CA20CB29B@kernel.crashing.org>
In-Reply-To: <108510B6-B9BE-49D4-BDCA-E25CA20CB29B@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707101721.58937.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 July 2007 16:16:29 Segher Boessenkool wrote:
> > gcc for i386 can be used with the assembly prefix ".code16gcc" to  
> > generate
> > 16-bit (real-mode) code.  This header file provides the assembly  
> > prefix.
> 
> This only works correctly with newer GCCs if you pass the
> -fno-toplevel-reorder option (and it only works on older
> GCC versions by accident).

And on older ones (gcc-3.3-hammer / 3.4 / 4.0 ) -fno-unit-at-a-time

Still it seems quite fragile to me agreed.

-Andi
