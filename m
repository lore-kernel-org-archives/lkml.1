Return-Path: <linux-kernel-owner+w=401wt.eu-S1755050AbZCPPPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050AbZCPPPi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 11:15:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752044AbZCPPP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 11:15:28 -0400
Received: from bipbip.grupopie.com ([195.23.16.24]:37782 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbZCPPP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 11:15:27 -0400
Message-ID: <49BE6D0B.7020507@grupopie.com>
Date: Mon, 16 Mar 2009 15:15:23 +0000
From: Paulo Marques <pmarques@grupopie.com>
Organization: Grupo PIE
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Alexey Fisher <bug-track@fisher-privat.net>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: smart cache. ist is possible?
References: <49BD1EB7.6080109@fisher-privat.net>
In-Reply-To: <49BD1EB7.6080109@fisher-privat.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Fisher wrote:
> Hallo all.

Hi,

> I found for my self how great is cache in linux. If read one file from
> disk, so i don't need to do it second time, chace will do the job. It
> speed up thing greatly. But i found it not working with realy big files.
> Like i have 4GB RAM, so if i read a file like 4.6GB, cache won't work.
> Is it possible to have some sort of smart cache wich will read for
> exaplme 1GB from disk and other part from cache?

This is something that depends on the page replacement algorithm. A
different page replacement algorithm might do better and there has been
some work in the past on this.

Check, for instance, this paper on Clock-Pro:

http://www.cse.ohio-state.edu/hpcs/WWW/HTML/publications/papers/TR-05-3.pdf

ISTR that Rik van Riel was doing an implementation of this algorithm for
the 2.6 kernel, but I don't remember how that ended up...

-- 
Paulo Marques - www.grupopie.com

"God is real, unless declared integer."
