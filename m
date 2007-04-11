Return-Path: <linux-kernel-owner+w=401wt.eu-S1752619AbXDKNPT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619AbXDKNPT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 09:15:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752631AbXDKNPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 09:15:18 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:20700 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752619AbXDKNPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 09:15:17 -0400
Message-ID: <461CDF8B.5060007@ru.mvista.com>
Date: Wed, 11 Apr 2007 17:15:55 +0400
From: Maxim Uvarov <muvarov@ru.mvista.com>
User-Agent: Debian Thunderbird 1.0.7 (X11/20051017)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: linux-kernel@vger.kernel.org, davidsen@tmr.com, randy.dunlap@oracle.com,
       Valdis.Kletnieks@vt.edu, jesper.juhl@gmail.com
Subject: Re: Performance Stats: Kernel patch
References: <461A4C1E.3070309@ru.mvista.com>	<20070410102111.923b92a9.dada1@cosmosbay.com>	<461CCD94.6010507@ru.mvista.com> <20070411142643.bb80522a.dada1@cosmosbay.com>
In-Reply-To: <20070411142643.bb80522a.dada1@cosmosbay.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:

>
>sysc_cnt being an 'unsigned long', its a 64 bits long integer...
>So you probably need ld/std instructions instead of lwz/stw
>
>  
>
Seems you are right again :(
