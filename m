Return-Path: <linux-kernel-owner+w=401wt.eu-S1758806AbYAPCyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758806AbYAPCyT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 21:54:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757935AbYAPCxv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 21:53:51 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:26136 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757719AbYAPCxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 21:53:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=JMef4xaJQnaavKLMWhRePtThKKdSp8A6xnQLUHgRPYZP/L+c0SvGbLIQvr5JtVM8M3xtrbpxrW0d/1LfJrry7HH7WimzohDBCzsAvRAHD6yy/vjMYBg+dzV4b5qzowtkzgQmf+MfRg3kafFqI02W+rgnPHBmzOP18nHV1gAf25s=
Message-ID: <478D71B6.7000400@gmail.com>
Date: Wed, 16 Jan 2008 11:53:42 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: linux-kernel@vger.kernel.org, daniel.ritz-ml@swissonline.ch,
       jeff@garzik.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH 4/4] libata: make libata use printk_header() and mprintk
References: <1200445210549-git-send-email-htejun@gmail.com>	<12004452112326-git-send-email-htejun@gmail.com> <20080115184819.78069cce.randy.dunlap@oracle.com>
In-Reply-To: <20080115184819.78069cce.randy.dunlap@oracle.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
>> -			ata_dev_printk(dev, KERN_WARNING,
>> -"Drive reports diagnostics failure. This may indicate a drive\n");
>> -			ata_dev_printk(dev, KERN_WARNING,
>> -"fault or invalid emulation. Contact drive vendor for information.\n");
>> -		}
> 
> Looks to me like several of these + lines have indent problems:
> following lines (i.e., not first line) of function call should be
> indented more than the first line:

Putting one more tab would put good part of those lines off the 80col
limit.  Hmmm... but I agree it looks ugly.  I'll add one or two spaces
there.

>> +		ata_dev_printk(dev, KERN_WARNING,
>> +		"Drive reports diagnostics failure. This may indicate a drive\n"
>> +		"fault or invalid emulation. Contact drive vendor for information.\n");

Thanks.

-- 
tejun
