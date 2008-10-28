Return-Path: <linux-kernel-owner+w=401wt.eu-S1753578AbYJ1VXI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753578AbYJ1VXI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 17:23:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753271AbYJ1VWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 17:22:49 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:55244 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754208AbYJ1VWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 17:22:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=OzmLCIt5ezthC8tEzv69GleZ7Gz9uPnYONeO2vRAN9X7RLDEGseibjm/0ulvZVd84h
         MSZzWc60Tru92nzNem/8GoEEB+WoU/R2diH59tOd0eTNbH9X03gP7gbC1QLk5PA7sVTC
         I0eaGDdA1xxZsFQgKiO8rs6hDW/adIElnwUfg=
Message-ID: <21a166410810281422r6638568au68af4e1367a04b87@mail.gmail.com>
Date: Tue, 28 Oct 2008 19:22:45 -0200
From: "Matias Zabaljauregui" <zabaljauregui@gmail.com>
To: "Glauber Costa" <glommer@redhat.com>
Subject: Re: [PATCH] regression: vmalloc easily fail.
Cc: "Avi Kivity" <avi@redhat.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, aliguori@codemonkey.ws, npiggin@suse.de,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Krzysztof Helt" <krzysztof.h1@poczta.fm>
In-Reply-To: <20081028210947.GA4269@poweredge.glommer>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1225234513-3996-1-git-send-email-glommer@redhat.com>
	 <49077E1A.5080105@redhat.com>
	 <20081028210947.GA4269@poweredge.glommer>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hello,

>> I'm guessing that the missing comment explains that this is intentional,
>> to trap buffer overflows?

yes, IIRC the pages between vmalloc areas are there for safety reasons.
(like the interval inserted before the first area, defined by VMALLOC_OFFSET)

regards
Matias
