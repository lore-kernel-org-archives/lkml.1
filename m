Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758059Ab0AOTMd (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 14:12:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757627Ab0AOTMc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 14:12:32 -0500
Received: from mail-yw0-f176.google.com ([209.85.211.176]:52379 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810Ab0AOTMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 14:12:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=fO/Gjn11uc+eMieH5NBdGLjQIrpbnTLBaA+PLoGl3jjHdzVBFUJ3bo34/kBoh0QEl9
         u2IxNOPJ7oLWI02HxmsxCMbsaLbB5Cb9XjukI2OHRy4WawQBWDcAb0lrS8mf6RgtJIMv
         BRbJ6QRKKlUzb6kFDfSAsaIP1vsDm8AxvGeuI=
Message-ID: <4B50BE1C.3070409@gmail.com>
Date: Fri, 15 Jan 2010 14:12:28 -0500
From: William Allen Simpson <william.allen.simpson@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Linux Kernel Developers <linux-kernel@vger.kernel.org>
CC: Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: [PATCH] tcp: input header length, prediction, and timestamp bugs
References: <4B49C2D0.1070704@gmail.com> <4B5078BB.40306@gmail.com>
In-Reply-To: <4B5078BB.40306@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

William Allen Simpson wrote:
> Finally, don't use TCPOLEN_MD5SIG_ALIGNED in the tcp_minisock.c
> last_seg_size calculations. It's not used in all other places, and may
> result in a too short estimate.
> 
> Instead, use the same calculations as tp->advmss in tcp_input.c.
> 
This part really shouldn't have been included in this patch, as it
depends on similar changes to tcp_output.c.  My mistake cutting the
patches apart from the bigger testing patch.

I'll send a new version promptly.
