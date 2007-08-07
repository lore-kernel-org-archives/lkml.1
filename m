Return-Path: <linux-kernel-owner+w=401wt.eu-S934295AbXHGTXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934295AbXHGTXz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 15:23:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755005AbXHGTXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 15:23:46 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:64715 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754605AbXHGTXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 15:23:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ZHMNemcG2r3MzY9hcPWrhqIx94Iwa31y9qfq8ctboDh07CpBJUbNn70Fgn9PdJdben4fEjZrEjk51scxsdT96lmFlqtaTwpYPNMfrtw0bkw+Yh0AhPywp6ElRsTi6iFsrUho8G/jzclKsKkdod/x9A6HxLFhlWRUkS7qGN4j4Hc=
Subject: Re: Disk spin down issue on shut down/suspend to disk
From: Michael Sedkowski <sedmich@gmail.com>
To: trenn@suse.de
Cc: Tejun Heo <htejun@gmail.com>, Robert Hancock <hancockr@shaw.ca>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-acpi@vger.kernel.org
In-Reply-To: <1186497925.8780.78.camel@queen.suse.de>
References: <fa.bsWpbo79BZgHoaIGhEMfTEBxs54@ifi.uio.no>
	 <fa.mg6p0itaOQUo/t8deCaYpyqj6Nk@ifi.uio.no>
	 <fa.RxWYL8z8KktgL8LGZ/cTB2nI1Yc@ifi.uio.no>
	 <fa.AyyCtZ2yLjC5noHPHtmzn4ffhhE@ifi.uio.no>
	 <fa.SuAjism+m0z0haqCRVjkc2S978o@ifi.uio.no>
	 <fa.QgWcLG2hfRb92g4blN61qYfRjlQ@ifi.uio.no> <46B7AF53.1040307@shaw.ca>
	 <46B8140E.3000509@gmail.com>  <1186497925.8780.78.camel@queen.suse.de>
Content-Type: text/plain
Date: Tue, 07 Aug 2007 21:23:38 +0200
Message-Id: <1186514618.5622.9.camel@nx6310>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I did some additional checking today...
On kernels prior to 2.6.22 line, the bug exists and manifests itself
exactly the same way. However, when I removed the "-h" flag
from /etc/init.d/halt, the drive spins down only once on "Power down"
message and there is no sign of the bug and the emergency unload count
remains constant. I've verified this on kernels 2.6.21.6; 2.6.20.4;
2.6.18-4-686-Etch.
The obvious conclusion is that something must have changed it the 2.6.22
kernels, so that removing the "-h" has no effect.
I dunno if my observations are of any value, but I thought You should
know...

Regards,
Michael

