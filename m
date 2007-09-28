Return-Path: <linux-kernel-owner+w=401wt.eu-S1761465AbXI1Jui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761465AbXI1Jui (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 05:50:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759550AbXI1JuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 05:50:15 -0400
Received: from an-out-0708.google.com ([209.85.132.241]:23663 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758143AbXI1JuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 05:50:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Z0TLsrjYuvJxre6r+w16rT0xTmAKTrfTow1kRHkOBrvD5ePDfO/dEAmyfFDOTQd4GVjXok9pry0EXtn9DkGxCwnf5qiy9W4y9YUPmnIYsL82Gjdc6wFyQqcqnoO2zUlauilKGL8tpQuOAmJB3wiXZKqEun13fPv4BstOnHtMEns=
Message-ID: <46FCCDEC.20200@gmail.com>
Date: Fri, 28 Sep 2007 02:48:28 -0700
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Mark Lord <liml@rtr.ca>
CC: Jeff Garzik <jgarzik@pobox.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       michal.k.k.piotrowski@gmail.com, bryan@arbores.ca,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH] libata drain fifo on stuck DRQ HSM violation
References: <46CFA08E.6090604@arbores.ca>	<6bffcb0e0708261610g10d9c59ck5789fac6feca9f42@mail.gmail.com>	<46DBCB6C.8080206@gmail.com>	<20070905095327.6277d054.akpm@linux-foundation.org>	<46DEE617.4050004@rtr.ca>	<46E0A253.7060803@gmail.com>	<46E154DE.2060602@rtr.ca>	<46FB563A.80108@gmail.com> <20070927193701.6230d77f@the-village.bc.nu> <46FC3D7D.90009@gmail.com> <46FC3FDD.5060201@pobox.com> <46FC423C.2050206@gmail.com> <46FC7B72.2030103@rtr.ca>
In-Reply-To: <46FC7B72.2030103@rtr.ca>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Drain up to 512 words from host/bridge FIFO on stuck DRQ HSM violation,
> rather than just getting stuck there forever.
> 
> Signed-Off-By:  Mark Lord <mlord@pobox.com>

Acked-by: Tejun Heo <htejun@gmail.com>

-- 
tejun
