Return-Path: <linux-kernel-owner+w=401wt.eu-S1752031AbZKLKH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031AbZKLKH5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 05:07:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751808AbZKLKH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 05:07:56 -0500
Received: from lo.gmane.org ([80.91.229.12]:44216 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751753AbZKLKHz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 05:07:55 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: =?ISO-8859-1?Q?J=F6rg-Volker_Peetz?= <jvpeetz@web.de>
Subject: Re: [PATCH 1/4] drivers/net/enic: decrement sizeof size in strncmp
Date: Thu, 12 Nov 2009 11:05:54 +0100
Message-ID: <4AFBDE02.20806@web.de>
References: <Pine.LNX.4.64.0911120848100.16627@ask.diku.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 129.26.101.112
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
In-Reply-To: <Pine.LNX.4.64.0911120848100.16627@ask.diku.dk>
Cc: netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julia Lawall wrote:
<snip>
> strncmp(foo, abc, 
> - sizeof(abc)
> + sizeof(abc)-1
>  )
<snip>
> -	if (strncmp(fw_info->hw_version, "A1", sizeof("A1")) == 0)
> +	if (strncmp(fw_info->hw_version, "A1", sizeof("A1") - 1) == 0)
>  		*hw_ver = VNIC_DEV_HW_VER_A1;
> -	else if (strncmp(fw_info->hw_version, "A2", sizeof("A2")) == 0)
> +	else if (strncmp(fw_info->hw_version, "A2", sizeof("A2") - 1) == 0)
<snip>
Why not use strlen(abc) instead of sizeof(abc) - 1 ?
-- 
Regards,
Jörg-Volker.

