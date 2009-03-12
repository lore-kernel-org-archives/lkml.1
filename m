Return-Path: <linux-kernel-owner+w=401wt.eu-S1754846AbZCLIUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846AbZCLIUc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 04:20:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751238AbZCLIUQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 04:20:16 -0400
Received: from mx1.auerswald.de ([212.185.163.234]:2791 "EHLO
	mail.auerswald.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751077AbZCLIUP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 04:20:15 -0400
From: Wolfgang =?iso-8859-1?q?M=FCes?= <wolfgang.mues@auerswald.de>
Organization: Auerswald GmbH & Co. KG
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: [PATCH 3/7] mmc_spi: adjust for delayed data token response
Date: Thu, 12 Mar 2009 09:20:06 +0100
User-Agent: KMail/1.9.10
Cc: "Pierre Ossman" <drzeus@drzeus.cx>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Matt Fleming" <matt@console-pimps.org>,
       "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
References: <200903111345.33154.david-b@pacbell.net>
In-Reply-To: <200903111345.33154.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200903120920.06935.wolfgang.mues@auerswald.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David,
Am Mittwoch, 11. März 2009 schrieb David Brownell:
> All hardware needs some bits to send binary data!!
>
> Do you mean "which don't send byte-aligned responses,
> contrary to MMC/SD/SDIO specifications"?

No. The specification states that the response from the card after a whole 
data block is received is IMMEDIATELY, with 0 bits delay. Not every card is 
able to do this all the time.

My comment is a little bit missleading, yes.

best regards
 
i. A. Wolfgang Mües
-- 
Auerswald GmbH & Co. KG
Hardware Development
Telefon: +49 (0)5306 9219 0
Telefax: +49 (0)5306 9219 94 
E-Mail: Wolfgang.Mues@Auerswald.de
Web: http://www.auerswald.de
 
--------------------------------------------------------------
Auerswald GmbH & Co. KG, Vor den Grashöfen 1, 38162 Cremlingen
Registriert beim AG Braunschweig HRA 13289
p.h.G Auerswald Geschäftsführungsges. mbH
Registriert beim AG Braunschweig HRB 7463
Geschäftsführer: Dipl-Ing. Gerhard Auerswald
