Return-Path: <linux-kernel-owner+w=401wt.eu-S1753034AbYDHOtI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034AbYDHOtI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 10:49:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751181AbYDHOsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 10:48:54 -0400
Received: from wx-out-0506.google.com ([66.249.82.230]:17710 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041AbYDHOsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 10:48:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=c9FVPgX91TM+J43J6j1C1iAJVkbSIs2tddrebu5M22J/EPjYtCHlMlZalkOEDsplNwTeI7JGVGdKog4fdaAj+pBRg/pOMzDAfRffD574SYrzgZIqQI0N+JdJK3hofLw7buyRSbf/qYCChddFjuXWqSvD2b1+FDBA0LIAFBfNCag=
Message-ID: <47FB85CB.2070506@gmail.com>
Date: Tue, 08 Apr 2008 23:48:43 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
CC: jgarzik@pobox.com, gregkh@suse.de, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 6/13] devres: implement managed iomap interface
References: <11684073371547-git-send-email-htejun@gmail.com> <47FA4FD2.8060808@ru.mvista.com>
In-Reply-To: <47FA4FD2.8060808@ru.mvista.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sergei Shtylyov wrote:
>    A very late comment but nevertheless... :-)

Better late than never.

>    Those functions are going to break on 32-bit platforms with extended 
> physical address (well, that's starting with Pentiums which had 36-bit 
> PAE :-) AND devices mapped beyond 4 GB (e.g. PowerPC 44x).  You should 
> have used resource_size_t for the 'offset' parameter. As this most 
> probably means that libata is broken on such platforms, I'm going to 
> submit a patch...

Yeah, right please go ahead.  But I wonder whether any BIOS was actually 
crazy enough to map mmio region above 4G on 32bit machine.

-- 
tejun
