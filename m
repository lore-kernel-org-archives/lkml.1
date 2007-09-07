Return-Path: <linux-kernel-owner+w=401wt.eu-S965102AbXIGA7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965102AbXIGA7W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 20:59:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964899AbXIGA7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 20:59:12 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:42372 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964892AbXIGA7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 20:59:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=nB4okT20/yR81YTj8obDRZ12V9wMjizsxYG5s0DjLTD1Y2Tys5dN/10FALSkM8qNKHUEBPvT2mjbYj4uIuVVUzL8dh8q0PHYOneKDwNU3w0iB6gr33R0OMYvfvXit2es+Rs7qkODAUbgtHGqPN2CGYc2/b5X+Gy7W3JBAwsOIkw=
Message-ID: <46E0A253.7060803@gmail.com>
Date: Fri, 07 Sep 2007 09:58:59 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Mark Lord <liml@rtr.ca>
CC: Andrew Morton <akpm@linux-foundation.org>, michal.k.k.piotrowski@gmail.com,
       bryan@arbores.ca, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: Stardom SATA HSM violation
References: <46CFA08E.6090604@arbores.ca>	<6bffcb0e0708261610g10d9c59ck5789fac6feca9f42@mail.gmail.com>	<46DBCB6C.8080206@gmail.com> <20070905095327.6277d054.akpm@linux-foundation.org> <46DEE617.4050004@rtr.ca>
In-Reply-To: <46DEE617.4050004@rtr.ca>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Mark Lord wrote:
> I reported a very similar bug back a few releases ago.
> Anyone who wants to try it themselves, can do this with hdparm-7.7 (from
> sourceforge):
> 
>    hdparm --drq-hsm-error /dev/sda
> 
> Whether or not it hangs the machine does depend upon exactly which SATA
> LLD is used,
> and what model/revision of drive is installed.  But if it hangs for you
> (eg. Tejun),
> then you now have a way to reproduce a HSM error "on demand" for
> testing.  :)

Neat.  Is this the FIFO-draining issue?

Thanks.

-- 
tejun
