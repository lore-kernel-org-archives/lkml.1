Return-Path: <linux-kernel-owner+w=401wt.eu-S1753789AbXGYEhi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789AbXGYEhi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 00:37:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750712AbXGYEhb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 00:37:31 -0400
Received: from wr-out-0506.google.com ([64.233.184.234]:31735 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323AbXGYEha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 00:37:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LDlgiBWVqYrEn47w9d19jrVLqV4QM8OMwSOWto5UyY6EAUdQ0C+5t1SbRKGO9Ao35JwCSfRk+wc8wlr++ALC6QcMnayJak2TXRaLc2oNgbbpQcPFBPTJuQpzvsHuflbQr09ed/Rqs4Sni7TSzX7/Pf+tAOch5Y2h4T5yNM2ziUo=
Message-ID: <21d7e9970707242137x51ca8a64wadfb06c7b543af38@mail.gmail.com>
Date: Wed, 25 Jul 2007 14:37:29 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Nick Piggin" <nickpiggin@yahoo.com.au>
Subject: Re: 2.6.23-rc1 regression: mm: fix fault vs invalidate race for linear mappings
Cc: "Bret Towe" <magnade@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <46A6C72A.9020801@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dda83e780707241027k369c2f01j6d16b21266df3a05@mail.gmail.com>
	 <46A6C72A.9020801@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>
> Is this with a binary-only module? We saw an issue with that in SLES9
> where the module is returning a locked page from its nopage handler
> when it isn't really supposed to. It might be fixed in latest drivers,
> have you tried them?

Doesn't sound like it he mentions radeon drm module which is open...

Dave.
