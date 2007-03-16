Return-Path: <linux-kernel-owner+w=401wt.eu-S1751952AbXCPIkR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952AbXCPIkR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 04:40:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753083AbXCPIkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 04:40:17 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:58422 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753096AbXCPIkQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 04:40:16 -0400
Message-ID: <45FA5810.7090101@drzeus.cx>
Date: Fri, 16 Mar 2007 09:40:48 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Philip Langdale <philipl@overt.org>
CC: LKML <linux-kernel@vger.kernel.org>,
       Carlos Aguiar <carlos.aguiar@indt.org.br>, juha.yrjola@solidboot.com
Subject: Re: [PATCH] MMC: Consolidate voltage definitions
References: <45F49B93.3020208@overt.org>
In-Reply-To: <45F49B93.3020208@overt.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Philip Langdale wrote:
> Consolidate the list of available voltages.
>
> Up until now, a separate set of defines has been
> used for host->vdd than that used for the OCR
> voltage mask values. Having two sets of defines
> allows them to get out of sync and the current
> sets are already inconsistent with one claiming
> to describe ranges and the other specific voltages.
>
> Only the SDHCI driver uses the host->vdd defines and
> it is easily fixed to use the OCR defines.
>
> Signed-off-by: Philip Langdale <philipl@overt.org>
>
>   

Looks good. I'll queue it up.

Rgds

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org

