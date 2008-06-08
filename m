Return-Path: <linux-kernel-owner+w=401wt.eu-S1757195AbYFHPmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757195AbYFHPmQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 11:42:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754668AbYFHPmD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 11:42:03 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:42245 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754549AbYFHPmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 11:42:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=w05p3kD3gZuS6t6+BqxpoEX3Lcbzfof1QPafG1QH8ckokI+V5XANCPu3dLO5NVfQAS
         BBb80qNe1ZmGppKWrD3P0hHT2Ke5LEOHcQGi61y/WQkKYlWTxRuWN8gwI7+DJWcSurYr
         GhMp9G6sOTAmNV0lazRgz2Qunq2YZLJ1KNvsQ=
Message-ID: <484BFDA9.7050308@gmail.com>
Date: Sun, 08 Jun 2008 10:41:29 -0500
From: Roger Heflin <rogerheflin@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Nick Craig-Wood <nick@craig-wood.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: libata.force=1.5Gbps doesn't seem to work
References: <20080608113527.GA5105@craig-wood.com>
In-Reply-To: <20080608113527.GA5105@craig-wood.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Craig-Wood wrote:
> Ever since I changed to AHCI (by fiddling with random options in the
> BIOS) my external SATA drive is being run at 3.0 Gbps.  However it
> doesn't seem reliable at that - maybe the cable is too long. (It is
> probably about 80cm in total - one standard SATA cable going to the
> case and another from the case to the drive).
> 
> I read in Documentation/kernel-parameters.txt that a command line of
> 
>   libata.force=1.5Gbps
> 
> Should force all my SATA disks to 1.5 Gbps.
> 
> However this doesn't seem to work.

I cannot help with the option not working, but you might see if the drives can 
be jumpered to force 1.5Gbps, I know a number of the manufacturers have jumpers 
to force 1.5Gbps since a number of older chipsets (Via sata and probably others) 
don't properly auto-neg 1.5Gbps on a 3.0Gbps drive, and fail to work at all.

                                  Roger
