Return-Path: <linux-kernel-owner+w=401wt.eu-S1764736AbXHGOip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764736AbXHGOip (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 10:38:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934740AbXHGOiA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 10:38:00 -0400
Received: from nz-out-0506.google.com ([64.233.162.238]:35466 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934728AbXHGOh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 10:37:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=qkTSd0bUZ4K88AkyDXUfNnjkYV7dMI51VuId2jPxqljQheHx6CCSzKoJ/BeRpmMdE/cu5ghblvR8AK6iEtYRRkAYrTNVSNOCHf9XrlnyTBYMlam3geE6x3GjWut/YWffymGGoObm4DIbJxC4ydZlC1wyITV/G50AVxJWUx8BE4E=
Message-ID: <46B883BB.10909@gmail.com>
Date: Tue, 07 Aug 2007 23:37:47 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: Michael Sedkowski <sedmich@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-acpi@vger.kernel.org, Thomas Renninger <trenn@suse.de>
Subject: Re: Disk spin down issue on shut down/suspend to disk
References: <fa.bsWpbo79BZgHoaIGhEMfTEBxs54@ifi.uio.no> <fa.mg6p0itaOQUo/t8deCaYpyqj6Nk@ifi.uio.no> <fa.RxWYL8z8KktgL8LGZ/cTB2nI1Yc@ifi.uio.no> <fa.AyyCtZ2yLjC5noHPHtmzn4ffhhE@ifi.uio.no> <fa.SuAjism+m0z0haqCRVjkc2S978o@ifi.uio.no> <fa.QgWcLG2hfRb92g4blN61qYfRjlQ@ifi.uio.no> <46B7AF53.1040307@shaw.ca> <46B8140E.3000509@gmail.com> <46B88173.3020302@shaw.ca>
In-Reply-To: <46B88173.3020302@shaw.ca>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> Tejun Heo wrote:
>> Yeah, that seems to be what's going on.  I don't think we have any other
>> choice than blacklisting those notebooks.  This is a mess.  How does the
>> other OS cope with this?
> 
> Quite possible that it gets a double spindown with these laptop/drive
> combinations as well. I don't think it's particularly harmful as long as
> there's no emergency unload..

I heard that spinning a harddrive back up while the platter is still
spinning from the previous spindown can have pretty bad affect on the
harddisk.  This is from a Samsung HDD service guy and I'm not sure how
credible it is at all.

Thanks.

-- 
tejun
