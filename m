Return-Path: <linux-kernel-owner+w=401wt.eu-S936829AbXFGVGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936829AbXFGVGk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 17:06:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754952AbXFGVGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 17:06:32 -0400
Received: from ik-out-1112.google.com ([66.249.90.180]:58587 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755239AbXFGVGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 17:06:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=rh/lY3TIrxdYibs5xbfsmcBuhk31n5yWIuLPZU9ulExa3WqOJ9PmEe05Rl9l9vSivbpi9xx3K0lNPI5vlcGxpDJdn4sVuHNOqDVpJiJJ3zIdtkq1IR/SGHDK9ZFUZCu3uFZ8hvDMkpbbrqXiGNrbiSTeXKmeNrkrdNz6yzDec+g=
Message-ID: <3d8471ca0706071406k4874f071q66affd33b79f1012@mail.gmail.com>
Date: Thu, 7 Jun 2007 23:06:29 +0200
From: "Guillaume Chazarain" <guichaz@yahoo.fr>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Davide Libenzi" <davidel@xmailserver.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Ulrich Drepper" <drepper@redhat.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Eric Dumazet" <dada1@cosmosbay.com>
In-Reply-To: <3d8471ca0706071359jfb79d84wbd34fef54d69ba3e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <send-serie.davidel@xmailserver.org.4625.1181169040.7>
	 <20070606235906.72439d16@the-village.bc.nu>
	 <alpine.LFD.0.98.0706071240150.4205@woody.linux-foundation.org>
	 <3d8471ca0706071359jfb79d84wbd34fef54d69ba3e@mail.gmail.com>
X-Google-Sender-Auth: 93d01faab35df44d
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/6/7, Guillaume Chazarain <guichaz@yahoo.fr>:

> Also, it sounds like a per-thread prctl, fun with syslets though ... ;-)

Oops, even if the user takes care to reset the prctl after his code (the
library problem), there are still signals that can run with an unexpected
prctl. Sorry for the noise.

-- 
Guillaume
