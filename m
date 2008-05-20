Return-Path: <linux-kernel-owner+w=401wt.eu-S932423AbYETUcj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932423AbYETUcj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 16:32:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759627AbYETUcb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 16:32:31 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:64170 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759588AbYETUca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 16:32:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=BxWaj/3hJ20z9bs+v97r3xShwvcYjdXdu6mK5xB5tY/fHqZx+C0CKl24/hcpgo70oIefuXTDfxu3ELSWU8v+eCF0Is5fSUcj9eZ54ya4Lwacx7nWKN+ELYpoWTXJtgiNVmt4IiA1VHaCeluTBtwmus6614wGumzORV/10f8dw7o=
Date: Tue, 20 May 2008 17:35:47 -0300
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: Anas Nashif <nashif@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Intel Management Engine Interface
Message-ID: <20080520203546.GA6129@Pilar.ictp.trieste.it>
References: <4832174A.20905@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4832174A.20905@linux.intel.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> --- /dev/null
> +++ b/drivers/char/heci/heci_data_structures.h
> [...]

> +#define SECOND_TO_MILLI                 1000
> +#define SECOND_TO_MICRO                 SECOND_TO_MILLI * 1000
> +#define SECOND_TO_100NANO               SECOND_TO_MICRO * 10

These definitions are not used in any file, why don't you remove
them?
