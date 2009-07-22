Return-Path: <linux-kernel-owner+w=401wt.eu-S1753543AbZGVQcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543AbZGVQcb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 12:32:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753489AbZGVQca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 12:32:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36927 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255AbZGVQc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 12:32:29 -0400
Message-ID: <4A67397F.8080705@zytor.com>
Date: Wed, 22 Jul 2009 09:08:31 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: kevin.granade@gmail.com
CC: Albin Tonnerre <albin.tonnerre@free-electrons.com>, linux@arm.linux.org.uk,
       alain@knaff.lu, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org
Subject: Re: [PATCH 3/5] Add support for LZO-compressed kernels
References: <0022152d7fe9b6dbcf046f4d04a6@google.com>
In-Reply-To: <0022152d7fe9b6dbcf046f4d04a6@google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kevin.granade@gmail.com wrote:
>  >
>  > So for a compression ratio that is still relatively close to gzip, it's
>  > much faster to extract, at least in that case.
> 
> Is that "time to run the extraction algorithm", or "time to read in 
> image from media and extract"? I think the time to read from the media 
> would tend to dominate the decompression time.
> Either way, could you provide the other time for each algorithm in order 
> to give a sense of how this might scale to other CPU speeds/media read 
> speeds?
> 

If you have very slow media, you probably want to use LZMA.  If you have 
a very slow CPU and comparatively fast media, LZO might be a good 
option... I have heard people asking for *uncompressed* kernels for this 
reason, but LZO runs at a significant fraction of memcpy() speed.

	-hpa
