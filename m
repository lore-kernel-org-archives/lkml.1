Return-Path: <linux-kernel-owner+w=401wt.eu-S1755141AbXJAUZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755141AbXJAUZ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 16:25:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752146AbXJAUZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 16:25:51 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:40776 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806AbXJAUZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 16:25:50 -0400
X-IronPort-AV: i="4.21,217,1188792000"; 
   d="scan'208"; a="52957390:sNHT314405350"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: david@lang.hm
Subject: Re: Out of memory management in embedded systems
Date: Mon, 1 Oct 2007 16:25:47 -0400
User-Agent: KMail/1.9.5
Cc: "Bernd Eckenfels" <ecki@lina.inka.de>, linux-kernel@vger.kernel.org
References: <E1IcGOu-0007sH-00@calista.eckenfels.net> <Pine.LNX.4.64.0710010916570.20712@asgard.lang.hm>
In-Reply-To: <Pine.LNX.4.64.0710010916570.20712@asgard.lang.hm>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200710011625.47466.rgetz@blackfin.uclinux.org>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Oct 2007 20:25:09.0340 (UTC) FILETIME=[2970E1C0:01C80469]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 1 Oct 2007 12:27, david@lang.hm pondered:
> overcommit by default is optimistic that if the program requesting the 
> memory actually tries to use it there will be enough (both the fork-exec
> situation and the copy-on-write memory of real forks mean that the
> system ends up useing much less memory then is theoretically allocated).
> 
> switching it to be pessimistic (overcommit 2 IIRC) means that the OOM 
> handler will never kick in, but it means that programs will be told that
> there isn't any memory when there really is enough for the program to 
> work.

I have set it to 2, and still get the OOM if I malloc too much... I never get 
a null back from malloc, no matter what I try.

-Robin
