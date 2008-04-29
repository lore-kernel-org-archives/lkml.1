Return-Path: <linux-kernel-owner+w=401wt.eu-S1758454AbYD2Ga7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758454AbYD2Ga7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 02:30:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755054AbYD2Gav
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 02:30:51 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:14014 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755011AbYD2Gau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 02:30:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=YkUxHHCdB2wxnNc9iEa9dcy8n2vVZC3AlvHupbSDjvDzak/ANUhCIJ67v+3TjRdDU/EIo+MzpFNk0eW6iJZ1/j4AaILvB2MirWFdezYM5z3gpO3sTFOzBbdDvLh1jodUjFJlDSK9jSlKYBQnOZqTcU5phx7nFN5LKRZh2uYHxIQ=
Message-ID: <4816C094.6030601@gmail.com>
Date: Tue, 29 Apr 2008 15:30:44 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Kumar Gala <galak@kernel.crashing.org>
CC: Andrew Morton <akpm@osdl.org>, jgarzik@pobox.com, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] devres: support addresses greater than an unsigned long
 via dev_ioremap
References: <Pine.LNX.4.64.0804290122210.10928@blarg.am.freescale.net>
In-Reply-To: <Pine.LNX.4.64.0804290122210.10928@blarg.am.freescale.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kumar Gala wrote:
> Use a resource_size_t instead of unsigned long since some arch's are
> capable of having ioremap deal with addresses greater than the size of a
> unsigned long.
> 
> Signed-off-by: Kumar Gala <galak@kernel.crashing.org>

Acked-by: Tejun Heo <htejun@gmail.com>

Thanks.

-- 
tejun
