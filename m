Return-Path: <linux-kernel-owner+w=401wt.eu-S1752953AbZEJQ2N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953AbZEJQ2N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 12:28:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751965AbZEJQ15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 12:27:57 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:42147 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634AbZEJQ14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 12:27:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:x-accept-language:mime-version:to
         :cc:subject:references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=wDewMR3/tG75B9vfR5ZT7LHEJExAb/UZCq1f/iaXN+LtbqGKk8S8rekbEoxQ4grNK6
         P16V6VE5AQeMTh727WH80t8jBcCy2RwHKRpzDtFr44em4xqbrQeQxSUnfwIBG96aVVWk
         zNRaKgsieaFKPF8PCd3nze+GY/gZBVFQd/rSA=
Message-ID: <4A070089.4090804@googlemail.com>
Date: Sun, 10 May 2009 18:27:53 +0200
From: Michael Riepe <michael.riepe@googlemail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.7.13) Gecko/20060417
X-Accept-Language: de-de, de, en-us, en
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: Francois Romieu <romieu@fr.zoreil.com>, Rui Santos <rsantos@grupopie.com>,
       =?ISO-8859-15?Q?Michael_B=FCker?= <m.bueker@berlin.de>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.27.19 + 28.7: network timeouts for r8169 and 8139too
References: <200903041828.49972.m.bueker@berlin.de> <200904041950.04324.mb@bu3sch.de> <4A06D8D2.4010505@googlemail.com> <200905101753.35282.mb@bu3sch.de>
In-Reply-To: <200905101753.35282.mb@bu3sch.de>
X-Enigmail-Version: 0.91.0.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Michael Buesch wrote:

>>It seems to me that this particular chip really doesn't like MSI.
> 
> 
> I can confirm this. I tried with msi enabled and it starts breaking
> after a few seconds of heavy transfers. Disabling MSI results in a reliable connection.
> 
> Maybe we should disable MSI as temporary workaround for affected chips?

Yep. It may not solve the problem, but it's a lot better than turning
MSI off for everything, including apparently working NICs that use the
same driver(s).

-- 
Michael "Tired" Riepe <michael.riepe@googlemail.com>
X-Tired: Each morning I get up I die a little
