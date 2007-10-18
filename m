Return-Path: <linux-kernel-owner+w=401wt.eu-S1762706AbXJRUqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762706AbXJRUqQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 16:46:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756011AbXJRUqB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 16:46:01 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:15577 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754846AbXJRUqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 16:46:00 -0400
Subject: Re: [PATCH] i386: fix TSC clock source calibration error
From: Daniel Walker <dwalker@mvista.com>
To: Dave Johnson <djohnson+linux-kernel@sw.starentnetworks.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <18196.53154.100115.92459@zeus.sw.starentnetworks.com>
References: <18196.53154.100115.92459@zeus.sw.starentnetworks.com>
Content-Type: text/plain
Date: Thu, 18 Oct 2007 13:43:34 -0700
Message-Id: <1192740214.17527.185.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-10-16 at 10:50 -0400, Dave Johnson wrote:
> 
>  range of tsc_khz  # of boots  % of boots
> -----------------  ----------  ----------
>         < 1999750           0      0.000%
> 1999750 - 1999800          21      3.048%
> 1999800 - 1999850         166     24.128%
> 1999850 - 1999900         241     35.029%
> 1999900 - 1999950         211     30.669%
> 1999950 - 2000000          42      6.105%
> 2000000 - 2000000           0      0.000%
> 2000050 - 2000100           0      0.000%
>                    [...]
> 2000100 - 2015000           1      0.145%  << BAD
> 2015000 - 2030000           6      0.872%  << BAD
> 2030000 - 2045000           1      0.145%  << BAD
> 2045000 <                   0      0.000%
> 
> The worst boot was 2032.577 Mhz, over 1.5% off!

Can you tell us what type of machine this was? I've seen complaints
where the SMI's can cause some other funny stuff with calibration , be
no one can every reproduce anything..

Daniel

