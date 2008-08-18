Return-Path: <linux-kernel-owner+w=401wt.eu-S1755751AbYHRR5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755751AbYHRR5Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 13:57:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753642AbYHRR5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 13:57:16 -0400
Received: from hpsmtp-eml17.kpnxchange.com ([213.75.38.117]:37248 "EHLO
	hpsmtp-eml17.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751811AbYHRR5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 13:57:15 -0400
From: Frans Pop <elendil@planet.nl>
To: Stefan Weinhuber <wein@linux.vnet.ibm.com>
Subject: Re: [PATCH] S390 : Set SLI on PSF/PRSSD on Dasd ECKD initialisation
Date: Mon, 18 Aug 2008 19:56:49 +0200
User-Agent: KMail/1.9.9
Cc: Ivan Warren <ivan@vmfacility.fr>, schwidefsky@de.ibm.com,
       linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1218726426.25578.0.camel@localhost> <48A58F9A.8070301@linux.vnet.ibm.com> <48A9AC82.5060505@vmfacility.fr>
In-Reply-To: <48A9AC82.5060505@vmfacility.fr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808181956.50108.elendil@planet.nl>
X-OriginalArrivalTime: 18 Aug 2008 17:57:12.0716 (UTC) FILETIME=[D7930CC0:01C9015B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 August 2008, Ivan Warren wrote:
> > The following patch works fine on current hardware. Can you please
> > verify that it indeed fixes your problem as well?
> >
> > Signed-off-by: Stefan Weinhuber <wein@de.ibm.com>

[...]

> Sorry for taking such a long time to respond..
>
> I like the patch. You are right, it's probably better to set the right
> length then hide it ! My initial rationale to SLI instead of altering
> the length was that I couldn't know if there was any obscure reason for
> setting the length to 16 instead of 12 (I thought it could have been
> related to DS8K PAV/HyperPAV support)..
>
> I also tried it on my rig, and it does seem to take care of the problem
>
>     Reviewed-by: Ivan Warren <ivan@vmfacility.fr>
>     Tested-by: Ivan Warren <ivan@vmfacility.fr>

Could this patch please also be pushed for the next stable update (2.6.26 
and maybe even 2.6.25) by adding:
      CC: stable <stable@kernel.org>
?

TIA,
FJP
