Return-Path: <linux-kernel-owner+w=401wt.eu-S934131AbYCFCmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934131AbYCFCmA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 21:42:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759949AbYCFClr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 21:41:47 -0500
Received: from rn-out-0910.google.com ([64.233.170.189]:19785 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760303AbYCFClq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 21:41:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=JtutvmmCx6UPXi9ZYFkCvcgrc4Kz1qCY97denJbS8Cxl9EByMmiMAuWkPJ1UMrqB2/Pjx3yJ++0GbQJ9+cHWjeKtLSQS3ZhbaHGxHo9P90fIRr/OiCsi6cCmpWS7YnP0QkvuE32v2WbwXxYhChFw35ZpnBUog3Vity/IstwS1cE=
Message-ID: <47CF59E6.4030303@gmail.com>
Date: Wed, 05 Mar 2008 18:41:42 -0800
From: Artie Ziff <artie.ziff@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
MIME-Version: 1.0
To: linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: make target `headers_install'
References: <47CF2525.9020304@gmail.com> <20080305151128.426192a1.randy.dunlap@oracle.com>
In-Reply-To: <20080305151128.426192a1.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> headers_install is a valid make target is "recent" (last year or
> so) kernels.  It's in the top-level Makefile.
>
> What kernel version are you using?
>
>   
My kernel is (necessarily) linux-2.6.16

That is clearly the issue. Thank you! 
I see such a target in the top level Makefile of linux-2.6.23.

Though, I am curious how people accomplished this before the special
target was introduced. That would be very useful to know. My
understanding was that running "make menuconfig" specifically would
write the include files (afterward I will build glibc using this
kernel's headers). In particular, I read that I'd know when the header
config process was complete by the existence of the file
"/include/linux/version.h"./  Though, I am not seeing this file or other
header files.

-az

