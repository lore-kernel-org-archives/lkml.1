Return-Path: <linux-kernel-owner+w=401wt.eu-S1755794AbYHHJkM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755794AbYHHJkM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 05:40:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753306AbYHHJj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 05:39:59 -0400
Received: from antispam.upcomillas.es ([130.206.70.245]:60295 "EHLO
	antispam.upcomillas.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753032AbYHHJj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 05:39:58 -0400
Message-ID: <489C1462.2000106@upcomillas.es>
Date: Fri, 08 Aug 2008 11:39:46 +0200
From: Romano Giannetti <romanol@upcomillas.es>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>, drzeus-mmc@drzeus.cx,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: SD cards stopped working on my machine
References: <489B1066.1020909@upcomillas.es>
In-Reply-To: <489B1066.1020909@upcomillas.es>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Romano Giannetti wrote:
> 
> 
> the new kernel stopped to notice the fact that I introduce an SD card 
> into the slot of the machine. It used to work perfectly in 2.6.26 (came 
> back and tested, so it's not hardware).
> 

Solved by setting to Y CONFIG_MMC_SDHCI_PCI which was set to N by make oldconfig.

Romano

-- 
Sorry for the disclaimer --- ¡I cannot stop it!


--
La presente comunicación tiene carácter confidencial y es para el exclusivo uso del destinatario indicado en la misma. Si Ud. no es el destinatario indicado, le informamos que cualquier forma de distribución, reproducción o uso de esta comunicación y/o de la información contenida en la misma están estrictamente prohibidos por la ley. Si Ud. ha recibido esta comunicación por error, por favor, notifíquelo inmediatamente al remitente contestando a este mensaje y proceda a continuación a destruirlo. Gracias por su colaboración.

This communication contains confidential information. It is for the exclusive use of the intended addressee. If you are not the intended addressee, please note that any form of distribution, copying or use of this communication or the information in it is strictly prohibited by law. If you have received this communication in error, please immediately notify the sender by reply e-mail and destroy this message. Thank you for your cooperation. 
