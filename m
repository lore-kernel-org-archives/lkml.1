Return-Path: <linux-kernel-owner+w=401wt.eu-S933525AbXCEPpH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933525AbXCEPpH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 10:45:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933533AbXCEPpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 10:45:06 -0500
Received: from py-out-1112.google.com ([64.233.166.176]:3246 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933525AbXCEPpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 10:45:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=IEWV04bnoS1kCahOAN7Y3IiZVvYMZzatulgz3wnYBJpbmB+fZqoK4qKtjXJvxLAGwifApNH3IcAaLN6OaxnGwJ0hU0gYrKBPws0JwKrhc/MTyEZacqBZ/z6nJ0RI4tJzC3hcFfh2tphCO9s+LKQCyk9iX1vpxSBmjr8+12LPKdQ=
Message-ID: <45EC3AFC.1050101@gmail.com>
Date: Tue, 06 Mar 2007 00:45:00 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: rol@as2917.net
CC: "'Jeff Garzik'" <jeff@garzik.org>,
       "'Andrew Morton'" <akpm@linux-foundation.org>,
       "'Linus Torvalds'" <torvalds@linux-foundation.org>,
       linux-ide@vger.kernel.org, "'LKML'" <linux-kernel@vger.kernel.org>,
       "'Eric D. Mudama'" <edmudama@gmail.com>
Subject: Re: [git patches] libata fixes
References: <00a001c75f0c$47f19750$4b00a8c0@donald>
In-Reply-To: <00a001c75f0c$47f19750$4b00a8c0@donald>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Rolland wrote:
> Hello,
> 
>> Your drive has some issues with NCQ and is scheduled to be blacklisted
>> such that it isn't enabled.  libata used to ignore the 
>> condition but now
>> considers it NCQ protocol violation and fails all pending commands.
> 
> OK, do you need an hdparm report to fully identify the disk ?

Nope, we already know.

>> libata EH should turn NCQ off automatically after a few of the above
>> errors.  I'd love to see how that actually works in the field (full
>> dmesg please).  If it doesn't, it needs fixing.
> 
> I'll get you one tonite, I don't have access to the machine right now.

Great. Thanks.

-- 
tejun
