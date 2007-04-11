Return-Path: <linux-kernel-owner+w=401wt.eu-S1161171AbXDKEVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161171AbXDKEVi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 00:21:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161175AbXDKEVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 00:21:38 -0400
Received: from wr-out-0506.google.com ([64.233.184.230]:36767 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161171AbXDKEVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 00:21:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=RhoqZlUc+94yhkSeQRdmVJJi50dr+FjpAwIdnKqoNnsUaR8tj4Ta0n6A22jNmpwfsmNcgebsi5O0n/BaleixbN1xOtZMxJJtQBzNcf+DBa1BHLdYfdV5odCwFYJFzycU3+s+DqIovVhIxzDgAhvhKEGH0kPlSl/vfaEhzXYO8y4=
Message-ID: <461C624A.3010002@gmail.com>
Date: Wed, 11 Apr 2007 13:21:30 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Cornelia Huck <cornelia.huck@de.ibm.com>
CC: gregkh@suse.de, maneesh@in.ibm.com, dmitry.torokhov@gmail.com,
       oneukum@suse.de, rpurdie@rpsys.net, James.Bottomley@SteelEye.com,
       stern@rowland.harvard.edu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/14] sysfs: kill unnecessary attribute->owner
References: <11760923261269-git-send-email-htejun@gmail.com>	<11760923293601-git-send-email-htejun@gmail.com>	<20070410161706.7764cd11@gondolin.boeblingen.de.ibm.com> <20070410163009.2d7371e9@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070410163009.2d7371e9@gondolin.boeblingen.de.ibm.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cornelia Huck wrote:
> On Tue, 10 Apr 2007 16:17:06 +0200,
> Cornelia Huck <cornelia.huck@de.ibm.com> wrote:
> 
>> You missed some s390 attributes :)

Yeap, I used allyesconfig on x86 to do the patch, so attrs on other
archs are not there.  I'll merge this patch and post the updated version.

Thanks.

-- 
tejun
