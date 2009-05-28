Return-Path: <linux-kernel-owner+w=401wt.eu-S1763844AbZE1SnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763844AbZE1SnS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 14:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755839AbZE1SnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 14:43:11 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:47381 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039AbZE1SnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 14:43:10 -0400
Message-ID: <4A1EDB3B.10402@davidnewall.com>
Date: Fri, 29 May 2009 04:13:07 +0930
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Olaf Kirch <okir@suse.de>
CC: linux-kernel@vger.kernel.org, mingo@redhat.com,
       Andreas Gruenbacher <agruen@suse.de>
Subject: Re: CFS Performance Issues
References: <200905281502.22487.okir@suse.de> <4A1EB272.3050902@davidnewall.com> <200905282020.09667.okir@suse.de>
In-Reply-To: <200905282020.09667.okir@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Olaf Kirch wrote:
>> About that: avg slice is in nsec, not msec (the old, off-by-one-million
>> bug), and utime, also an average, is in usec.
>>     
> ...
> 	utime / ninvcsw / 1000
>
> which is a millisecond quantity.
>   

Sorry.  My confusion.  (The old, divide-instead-of-multiply bug.)
