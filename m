Return-Path: <linux-kernel-owner+w=401wt.eu-S1763375AbXJZDC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763375AbXJZDC4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 23:02:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758252AbXJZDCp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 23:02:45 -0400
Received: from rv-out-0910.google.com ([209.85.198.188]:28585 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758027AbXJZDCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 23:02:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=NTpESTxIZ29lbfnj5gIOBbKd+OedwWQ9DqOiIAJ5aROtfY8tHgCNx/lwtaEdcVNFOmx1eoRZvWUdLWF4J467xkLjFYM1bKPqN8GV8BAXClaP6MqJCsmDd6eGQd68VhKjwfMZMgCgU3mbpuMa+roaFtJRjn81N5pk+VuuumLzloM=
Message-ID: <472158CA.1090600@gmail.com>
Date: Fri, 26 Oct 2007 12:02:34 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Andrey Borzenkov <arvidjaar@mail.ru>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [git patches] libata update
References: <20071012194002.GA1545@havoc.gtf.org> <20071013070535.D339CA364AB@smtp01.mtu.ru> <4710A420.9000108@garzik.org>
In-Reply-To: <4710A420.9000108@garzik.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Andrey Borzenkov wrote:
>> Jeff Garzik wrote:
>>
>>> * Asynchronous notification -- finally userspace CD-ROM polling can go
>>> away!
>>>   (NOTE: waiting on James B to apply the piece that actually makes this
>>>   work...)
>>
>> Does it depend on hardware offering suitable support? What are chances
>> for
>> it to work on 5 years old DVD-ROM?
> 
> Correct -- it requires a new SATA CD-ROM with the AN capability.

And some SATA CD-ROMs lie about AN capability and sends nothing when
media event occurs.  Do we need to start a blacklist or whitelist?  :-)

-- 
tejun
