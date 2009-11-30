Return-Path: <linux-kernel-owner+w=401wt.eu-S1752885AbZK3Kuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885AbZK3Kuj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 05:50:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751806AbZK3Kuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 05:50:39 -0500
Received: from smtp.nokia.com ([192.100.105.134]:50484 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792AbZK3Kui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 05:50:38 -0500
Date: Mon, 30 Nov 2009 12:43:53 +0200
From: Eduardo Valentin <eduardo.valentin@nokia.com>
To: "Valentin Eduardo (Nokia-D/Helsinki)" <eduardo.valentin@nokia.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       "Hogander Jouni (Nokia-D/Tampere)" <jouni.hogander@nokia.com>,
       "De-Schrijver Peter (Nokia-D/Helsinki)" 
	<Peter.De-Schrijver@nokia.com>,
       "Keski-Saari Juha.1 (EXT-Teleca/Helsinki)" 
	<ext-juha.1.keski-saari@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: Doubt about Regulator Framework and VBAT use case
Message-ID: <20091130104353.GB16608@esdhcp037198.research.nokia.com>
Reply-To: eduardo.valentin@nokia.com
References: <20091130104102.GA16608@esdhcp037198.research.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091130104102.GA16608@esdhcp037198.research.nokia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 30 Nov 2009 10:44:00.0282 (UTC) FILETIME=[069D1FA0:01CA71AA]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Forgot to add Liam into Cc. Doing it so.


On Mon, Nov 30, 2009 at 11:41:02AM +0100, Valentin Eduardo (Nokia-D/Helsinki) wrote:
> Hello Mark and Liam,
> 
> I'm writing to ask about VBAT use case. What is the expected
> way to use regulator framework in case of rail coming from battery?
> Should it be added to the regulator framework at all?
> 
> In that case, the rail should not be controllable. So I don't see
> any reason to add it to the regulator framework board definitions,
> as we should not be controlling it.
> 
> However, drivers for devices on that rail would require their regulator anyway.
> And I guess the point would be that drivers should not be aware that they are on VBAT
> or any other rail.
> 
> So, what's the correct way to solve this?
> 
> - Should drivers fail nicely if a regulator_get fail? And continue even if one fails.
> - Should drivers disable regfw usage completely in the driver if regulator_get doesn't
> give valid regulator ?
> - or Should a fake fixed regulator be added for vbat so drivers can still get a valid
> regulator with regulator_get.
> 
> The last options seams to be the one that does not require much changes on drivers.
> But it will be adding a regulator that does basically nothing in the system.
> 
> BR,
> 
> -- 
> Eduardo Valentin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Eduardo Valentin
