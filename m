Return-Path: <linux-kernel-owner+w=401wt.eu-S2993321AbXDTUP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993321AbXDTUP3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 16:15:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993323AbXDTUPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 16:15:18 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:35965 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993315AbXDTUPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 16:15:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=dSxSEDw1LGpryTHzTSvZNl8UlnChQ5/3GgngZNw+pSPIg8cYq1K9SnM7kNSKV0xaQxsInvUNBKHvxflRwhCEpl+fTycNkyxtpcUqbl1NoenAUHtRQfNnfzqq3Ysc3cE0XNAj1WJvCOC1ClvKhSTlTYjmQJJDuoAi4r81TqweFBk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH pata-2.6 fix queue] hpt366: fix kernel oops with HPT302N
Date: Fri, 20 Apr 2007 21:54:52 +0200
User-Agent: KMail/1.9.6
Cc: codermattie@gmail.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200702032309.43867.sshtylyov@ru.mvista.com> <200702162321.40813.sshtylyov@ru.mvista.com> <200704182338.00604.sshtylyov@ru.mvista.com>
In-Reply-To: <200704182338.00604.sshtylyov@ru.mvista.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200704202154.52254.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 April 2007, Sergei Shtylyov wrote:
> The driver crashes the kernel on HPT302N chips due to the missing initializer
> for 'hpt302n.settings' having been unfortunately overlooked so far. :-<
> 
> Much thanks to Mike Mattie for pin-pointing the reason of crash.
> 
> Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

applied
