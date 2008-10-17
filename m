Return-Path: <linux-kernel-owner+w=401wt.eu-S1754585AbYJQEPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585AbYJQEPA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 00:15:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750838AbYJQEOr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 00:14:47 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:24592 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753015AbYJQEOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 00:14:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=bHvEwOXkc6psXT2ieoOUPMF5xwfXEI1UDwdKnii5gMZW477akXdRGxMdJKqlfjaHlC
         sJKL1YrWng4Xh0KHeGPgVNljjZME2TqA60qVmjaq8+NyqCSpp35qYcKO3VUsJwYlx8aj
         TwG/L1nsHMM8ZEpsfFYZiLqeTD77wR6NwWlZY=
Message-ID: <48F810F3.8080409@gmail.com>
Date: Fri, 17 Oct 2008 10:13:39 +0600
From: "Alexander E. Patrakov" <patrakov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; ru-RU; rv:1.8.1.16) Gecko/20080718 SeaMonkey/1.1.11
MIME-Version: 1.0
To: Jeremy Huntwork <jhuntwork@lightcubesolutions.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: headers_install broken on early versions of perl
References: <EA1CEB12-7E00-4939-AFA9-84B865E185B4@lightcubesolutions.com>
In-Reply-To: <EA1CEB12-7E00-4939-AFA9-84B865E185B4@lightcubesolutions.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Huntwork wrote:
> Hello,
> 
> This may not be a very large concern, but the new headers_install.pl and 
> headers_check.pl scripts do not work with versions of Perl < 5.6.0. This 
> is largely to do with syntax changes in that version. Previously, open() 
> only allowed two arguments. The following patch (against 2.6.27.1) 
> alters the syntax to be backwards compatible with earlier versions. It 
> has been tested on 5.005_03, and 5.8.8.
> 
> Please CC me on any comments as I am not subscribed to this list.
> 
> Thanks,
> 
> Jeremy Huntwork
> 
> 
> diff -Naur linux-2.6.27.1.orig/scripts/headers_check.pl 
> linux-2.6.27.1/scripts/headers_check.pl
> --- linux-2.6.27.1.orig/scripts/headers_check.pl        Wed Oct 15 
> 19:02:53 2008
> +++ linux-2.6.27.1/scripts/headers_check.pl     Thu Oct 16 19:10:37 2008

There is no Signed-off-by: header in your mail, this is a formal reason 
for rejection. Please read Documentation/SubmittingPatches and retry.

-- 
Alexander E. Patrakov
