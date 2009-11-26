Return-Path: <linux-kernel-owner+w=401wt.eu-S1752294AbZKZXwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752294AbZKZXwA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 18:52:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751523AbZKZXwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 18:52:00 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:61464 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254AbZKZXv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 18:51:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=MbK05WiQKAlLMIKFu4SsZpkMx/K4Pu7wbRNd0V5IwfGnw/YkbXQNX+q8K1Nb1stOJL
         c45GPOacA8H9vo4GxVr89l+YkDnW500esO2mJw31x5sN7t9497//Mp9AFDGrx8JtT4L6
         X5+UGv7rd5Cx0n/4uN/qc0tRHQNc0Ssg93mis=
Subject: Re: [PATCH] Port ricoh_mmc from driver to pci quirk.
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Philip Langdale <philipl@overt.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Pierre Ossman <pierre@ossman.eu>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20091125173019.74d0ddb9@fido2.homeip.net>
References: <1259021583.16650.9.camel@maxim-laptop>
	 <20091123162119.3777e14d@fido2.homeip.net>
	 <1259160947.10147.1.camel@maxim-laptop>
	 <1259161121.10147.4.camel@maxim-laptop>
	 <20091125085324.1ef9ae1f@fido2.homeip.net>
	 <20091125113501.1f4d42b9.akpm@linux-foundation.org>
	 <1259192401.15916.48.camel@maxim-laptop>
	 <20091125173019.74d0ddb9@fido2.homeip.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 27 Nov 2009 01:51:59 +0200
Message-ID: <1259279520.3991.5.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I send now an updated version, and hope it addresses most of the issues.
I added proper changelog, put the quirk under kconfig define (same as
was before) and added a message to kernel log about the disablement.

I must note that this wasn't tested with real mmc card.
It should work correctly though.

What does work for sure is that MMC device disappears just like it did
before, but now pci understands this.

Best regards,
Maxim Levitsky

