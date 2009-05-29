Return-Path: <linux-kernel-owner+w=401wt.eu-S1755863AbZE2HtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863AbZE2HtU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 03:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754297AbZE2HtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 03:49:10 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:58938 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753862AbZE2HtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 03:49:09 -0400
From: Christian =?iso-8859-15?q?Borntr=E4ger?= <borntraeger@de.ibm.com>
Organization: IBM
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Subject: Re: [PATCH] KVM: add localversion to avoid confusion and conflicts
Date: Fri, 29 May 2009 09:48:32 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc6-self-00072-g279e677-dirty; KDE/4.2.2; i686; ; )
Cc: Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, KVM list <kvm@vger.kernel.org>
References: <1243581494.3212.1.camel@localhost.localdomain>
In-Reply-To: <1243581494.3212.1.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905290948.34482.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag 29 Mai 2009 09:18:14 schrieb Jaswinder Singh Rajput:
> Adding localversion avoids confusion in kernel images :
>
> like Linux version 2.6.30-rc7 does not tell whether it is linus or kvm
> kernel.
>
> By adding localversion it tells :
>
> Linux version 2.6.30-rc7-kvm , any doubt ;-)
> I am inspired by Ingo's -tip, I am sure Ingo will tell more advantages,
> if these are not enough :-)
[...]
> diff --git a/localversion-kvm b/localversion-kvm
> new file mode 100644
> index 0000000..d969ff0
> --- /dev/null
> +++ b/localversion-kvm
> @@ -0,0 +1 @@
> +-kvm

NAK from my side. If you need a distinction, there is always 
CONFIG_LOCALVERSION_AUTO. If you need this kind of prefix, there is always  
CONFIG_LOCALVERSION.

Christian

