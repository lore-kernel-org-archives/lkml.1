Return-Path: <linux-kernel-owner+w=401wt.eu-S1753047AbXHEENj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047AbXHEENj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 00:13:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750885AbXHEEN3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 00:13:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58641 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773AbXHEEN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 00:13:29 -0400
Message-ID: <46B54D76.6060300@zytor.com>
Date: Sat, 04 Aug 2007 23:09:26 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Jesper Juhl <jesper.juhl@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Carlos Puchol <cpglinux@puchol.com>, hpa@transmeta.com,
       David Airlie <airlied@linux.ie>
Subject: Re: [PATCH][RESEND] efficeon-agp leaks 'struct agp_bridge_data' in
 error paths of agp_efficeon_probe()
References: <200708042030.58259.jesper.juhl@gmail.com>
In-Reply-To: <200708042030.58259.jesper.juhl@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jesper Juhl wrote:
> (This is a resend of a patch originally submitted on 24-Jul-2007 00:14)
> 
> 
> Ok, this is something the coverity checker found (CID: 1813). 
> I'm not at all intimate with this code, so I'm not sure if this 
> attempt at a fix is correct (but at least it compiles).
> 
> Please look it over and NACK if bad or merge if good ;-)
> 

Looks sensible to me.

	-hpa

