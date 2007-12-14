Return-Path: <linux-kernel-owner+w=401wt.eu-S1765277AbXLNCGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765277AbXLNCGx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 21:06:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934556AbXLNCGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 21:06:32 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:62068 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934354AbXLNCGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 21:06:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=uPj10Fh127HWau13nRt1F3eyTzoBE7qntSOENcCNcsWGgw8xJd1Kg03i1rdBc5vSPcTaDAsJFTkhkQnKryqiYe6c3izPbAazgpQzdWLGc6QJ74EoD+izBy0iZ+A8hWZuwFqUAXZSRRQWS551rH1Q4YyinabsUZ58i0Ouq9PbPKA=
Message-ID: <b25c3fa70712131806i6520057bt2dadbb4a06d9cf57@mail.gmail.com>
Date: Fri, 14 Dec 2007 11:06:29 +0900
From: "Joonwoo Park" <joonwpark81@gmail.com>
To: "Andrew Gallatin" <gallatin@myri.com>
Subject: Re: [RFC] net: napi fix
Cc: "Kok, Auke" <auke-jan.h.kok@intel.com>,
       "David Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, jgarzik@pobox.com,
       shemminger@linux-foundation.org,
       "Jesse Brandeburg" <jesse.brandeburg@intel.com>
In-Reply-To: <47613E22.6060705@myri.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47601A73.5010804@myri.com>
	 <20071212.093819.205755031.davem@davemloft.net>
	 <47602B77.2090202@intel.com>
	 <b25c3fa70712122341q3ba282cdqda3fa56901b14484@mail.gmail.com>
	 <47613E22.6060705@myri.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2007/12/13, Andrew Gallatin <gallatin@myri.com>:
>
> If the netif_running() check is indeed required to make a device break
> out of napi polling and respond to an ifconfig down, then I think the
> netif_running() check should be moved up into net_rx_action() to avoid
> potential for driver complexity and bugs like the ones you found.
>
> Drew
>

Yep, It looks good.

Joonwoo
