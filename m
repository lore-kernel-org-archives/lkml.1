Return-Path: <linux-kernel-owner+w=401wt.eu-S1753601AbZHJKMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601AbZHJKMt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 06:12:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753505AbZHJKMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 06:12:48 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:65310 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366AbZHJKMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 06:12:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=S/0ZtWkgOEFcHU/Pyg9+ZqAAu6yFr0sPN2/2pabTpp4CSHcvtPOTvja14i+RI5WGCi
         B6i6QSk/MhY7uyaySFxoxdU/LPr6wq7tvmmRgfytQmogCEdtyKCA1SK8pK1BnFa6Zw6V
         1QIRcQHh3ISQrJG74u77fhKZ4PV1Xkvcx0Qwc=
From: Chris Clayton <chris2553@googlemail.com>
Reply-To: chris2553@googlemail.com
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #13846] LEDs switched off permanently by power saving with rt61pci driver
Date: Mon, 10 Aug 2009 11:11:16 +0100
User-Agent: KMail/1.9.10
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       linux-wireless@vger.kernel.org
References: <AuPdDySr74O.A.5LC.Pj1fKB@chimera> <u1L1PAbl8zG.A.EjD.3j1fKB@chimera>
In-Reply-To: <u1L1PAbl8zG.A.EjD.3j1fKB@chimera>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908101111.16762.chris2553@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

On Sunday 09 August 2009, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.30.  Please verify if it still should be listed and let me know
> (either way).
>

Ivo sent a test patch for this and I tested it., but without success. I reported my findings but 
didn't get a reply. See http://marc.info/?l=linux-wireless&m=124940189007154&w=4.

I suspect the failure is due to the same PS hardware probelms that were at the route of my original 
report.. Unless one of the wireless folks say otherwise, I think we should close this on the basis 
of busted hardware. I'm happy to simply eject the card and re-insert it now that I have some udev 
scripts to tear down the wireless configuration on the ejection and set it uop again when the card 
is re-inserted.

Thanks

Chris


>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13846
> Subject		: LEDs switched off permanently by power saving with rt61pci
> driver Submitter	: Chris Clayton <chris2553@googlemail.com>
> Date		: 2009-07-13 8:27 (28 days old)
> References	: http://marc.info/?l=linux-kernel&m=124747418828398&w=4


-- 
No, Sir; there is nothing which has yet been contrived by man, by which so much happiness is 
produced as by a good tavern or inn - Doctor Samuel Johnson
