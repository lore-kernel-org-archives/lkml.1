Return-Path: <linux-kernel-owner+w=401wt.eu-S932561AbXBWPZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932561AbXBWPZ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 10:25:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932613AbXBWPZ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 10:25:26 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:19536 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932561AbXBWPZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 10:25:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:sender;
        b=i9o7WgzOJd47sHe7ZIrRT8BiJVY/gVrOFLqEXgYymEnBCeFs/QzkUdKXoDcKuBJr7HfEEWRbnLlRpMBnbgJvcl6RoSpoebNG6jyakifFnJ+pr+h3nTyZWarbN6YXK/adbrenAOQraa0N4ztct6hhyPY2pqjA7k9A4XYkqA1rcdw=
Date: Fri, 23 Feb 2007 15:24:11 +0000
From: Frederik Deweerdt <deweerdt@free.fr>
To: Allexio Ju <allexio.ju@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: trivial question regarding byte ordering
Message-ID: <20070223152411.GA31486@slug>
References: <a02278b00702230718i74df1d63g954bd7ac83298696@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a02278b00702230718i74df1d63g954bd7ac83298696@mail.gmail.com>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 23, 2007 at 07:18:13AM -0800, Allexio Ju wrote:
> Is there a API (or macro) that checks CPU endianness and does byte
> ordering conversion on given data (32-bit) if endianness is
> big-endian?
including include/asm/byteorder.h will define the needed
cpu_to_{b,l}e{16,32,64} and {b,l}e{16,32,64}_to_cpu macros.

Regards,
Frederik
