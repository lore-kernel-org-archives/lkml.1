Return-Path: <linux-kernel-owner+w=401wt.eu-S1763426AbXF0W3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763426AbXF0W3i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 18:29:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756292AbXF0W3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 18:29:31 -0400
Received: from terminus.zytor.com ([192.83.249.54]:41777 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbXF0W3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 18:29:30 -0400
Message-ID: <4682E1AE.1000908@zytor.com>
Date: Wed, 27 Jun 2007 18:16:14 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>
CC: bunk@stusta.de, dwmw2@infradead.org, david@lang.hm,
       linux-kernel@vger.kernel.org, schilling@fokus.fraunhofer.de
Subject: Re: Linux Kernel include files
References: <46826a08.aydgAULQ8LQL0IWi%Joerg.Schilling@fokus.fraunhofer.de>
In-Reply-To: <46826a08.aydgAULQ8LQL0IWi%Joerg.Schilling@fokus.fraunhofer.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Schilling wrote:
> 
> After copying /usr/include/linux/types.h  to
> /opt/sunstudio12/prod/include/cc/linux/types.h and removing all 
> 
> #if defined(__GNUC__) && !defined(__STRICT_ANSI__) 
> ...
> #endif
> 
> stuff, I got cdrtools compiled using "suncc" and I did even get a woring 
> cdrecord.
> 

Indeed, this guard is bogus.

	-hpa

