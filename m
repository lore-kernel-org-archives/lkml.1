Return-Path: <linux-kernel-owner+w=401wt.eu-S1758640AbZEVFFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758640AbZEVFFk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 01:05:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758154AbZEVFCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 01:02:55 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:33851 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758180AbZEVFCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 01:02:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=d/qTiG1UQmU1HzCXTFA6PaAbmncc8ntBxajM7tZfaPIs4KF4+C39g16weUTJ2iOJPL
         1gItt47lGN7zrsSEbCfMTbib5oUsiV2CK1+oR7aH29jje5QmuLDpXVfcxAGeydP1bsl0
         4HtpnBleJkYqNomqnK1vERonADT9bgLuN7Pyg=
Date: Fri, 22 May 2009 09:02:54 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       torvalds@linux-foundation.org, xemul@parallels.com,
       orenl@cs.columbia.edu, serue@us.ibm.com, dave@linux.vnet.ibm.com,
       mingo@elte.hu
Subject: Re: [PATCH 01/38] cred: #include init.h in cred.h
Message-ID: <20090522050254.GA1174@x200.localdomain>
References: <1242968132-1044-1-git-send-email-adobriyan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1242968132-1044-1-git-send-email-adobriyan@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

More patches before "[PATCH 18/38] C/R: core stuff" were already
sent via usual channels and some are already in -next.
There are being repeated to maintain clean series against mainline.

I forgot to mention that ->checkpoint hook was not added to vDSO
mapping for several reasons so if someone want to test, boot with
vdso=0 for now.
