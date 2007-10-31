Return-Path: <linux-kernel-owner+w=401wt.eu-S1759251AbXJaM64@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759251AbXJaM64 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 08:58:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755195AbXJaM6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 08:58:49 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:21768 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996AbXJaM6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 08:58:48 -0400
Message-ID: <47287C05.5060903@fr.ibm.com>
Date: Wed, 31 Oct 2007 13:58:45 +0100
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Pavel Emelyanov <xemul@openvz.org>
CC: Andrew Morton <akpm@osdl.org>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Serge Hallyn <serue@us.ibm.com>,
       Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] Move the UTS namespace under the option
References: <47285FEE.9030001@openvz.org> <472861D3.4060303@openvz.org>
In-Reply-To: <472861D3.4060303@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> diff --git a/init/Kconfig b/init/Kconfig
> index fc76773..d592aa2 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -409,6 +409,13 @@ config NAMESPACES
>  	  or same user id or pid may refer to different tasks when used in
>  	  different namespaces.
> 
> +config UTS_NS
> +	bool "UTS namespace"
> +	depends on NAMESPACES

should we add a 'default y' like in 2.6.23 ?

C.
