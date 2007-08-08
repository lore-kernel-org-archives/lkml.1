Return-Path: <linux-kernel-owner+w=401wt.eu-S1764705AbXHHQVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764705AbXHHQVS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 12:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764709AbXHHQUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 12:20:37 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:27754 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763685AbXHHQUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 12:20:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=mhdvAvVGwhIkZgOQMNncF0ryXxwZxvbPyutQ0gizck9KbGGa4RELO3SNLA+vHD3Ql3Sb7ki3sytbsz0/hjAwt7pbIuZahH4l5Pwl50Iaa1LZT6hOt0iFJfyJqL5+If62d+AzkEqX2XRP0OfWtk55Ua5vIJXrxQRXSxv30RVayWA=
Message-ID: <46B9ED48.1010901@gmail.com>
Date: Thu, 09 Aug 2007 01:20:24 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Mark Lord <liml@rtr.ca>
CC: Michael Sedkowski <sedmich@gmail.com>, trenn@suse.de,
       Robert Hancock <hancockr@shaw.ca>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: Disk spin down issue on shut down/suspend to disk
References: <fa.bsWpbo79BZgHoaIGhEMfTEBxs54@ifi.uio.no>	 <fa.mg6p0itaOQUo/t8deCaYpyqj6Nk@ifi.uio.no>	 <fa.RxWYL8z8KktgL8LGZ/cTB2nI1Yc@ifi.uio.no>	 <fa.AyyCtZ2yLjC5noHPHtmzn4ffhhE@ifi.uio.no>	 <fa.SuAjism+m0z0haqCRVjkc2S978o@ifi.uio.no>	 <fa.QgWcLG2hfRb92g4blN61qYfRjlQ@ifi.uio.no> <46B7AF53.1040307@shaw.ca>	 <46B8140E.3000509@gmail.com>  <1186497925.8780.78.camel@queen.suse.de> <1186514618.5622.9.camel@nx6310> <46B9307D.3000105@gmail.com> <46B9CE79.5030307@rtr.ca> <46B9CFB3.6020402@gmail.com> <46B9D219.6030509@rtr.ca> <46B9DF91.7050709@rtr.ca> <46B9E2C4.7070307@rtr.ca>
In-Reply-To: <46B9E2C4.7070307@rtr.ca>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Further to this, if I have an active-writer running at the time of suspend,
> then even my scripted "sleep 1" is not good enough, as additional writes
> are still happening before/after the flush.
> 
> Now I'll reboot and try it with the "sleep 1" hardcoded inside
> sd_suspend().

Hmmm... queue quiescing might be broken.  Can you verify there's no
command issued between STANDBYNOW1 and suspending?

-- 
tejun
