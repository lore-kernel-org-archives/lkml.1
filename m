Return-Path: <linux-kernel-owner+w=401wt.eu-S1767241AbXCIMyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767241AbXCIMyT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 07:54:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767240AbXCIMyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 07:54:19 -0500
Received: from nz-out-0506.google.com ([64.233.162.225]:6036 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767236AbXCIMyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 07:54:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=PKtIxBqcLgNjjdUNnXkPJTkI2KNDggIkRVpxKBagC4evnvV5Wse1jUG46aau3zp3jISKFz8X25uBkUWQAi9J7IkPHCWw4qIYhpunXlEzgWeTW2QL4W+ptL5hiadY9UQKPwryhjHFlVakNmM+tsaWbfcUtNc5xugLjyAj2qP26Dg=
Message-ID: <45F158F2.9040907@gmail.com>
Date: Fri, 09 Mar 2007 21:54:10 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Sergei Shtylyov <sshtylyov@ru.mvista.com>, Greg KH <greg@kroah.com>,
       linux-pci@atrey.karlin.mff.cuni.cz, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@osdl.org>, Jeff Garzik <jgarzik@pobox.com>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: 2.6.20-rc4-mm1: PCI=n: drivers/net/3c59x.c compile error
References: <20070111222627.66bb75ab.akpm@osdl.org>	<20070124135354.GI17836@stusta.de>	<45B76946.1070009@ru.mvista.com>	<45D756D7.4060106@ru.mvista.com>	<45D75853.1060607@ru.mvista.com>	<45E2DF13.9010200@ru.mvista.com>	<20070226092644.aea76b37.randy.dunlap@oracle.com>	<20070226211401.GC3810@kroah.com>	<45ED9390.3000308@ru.mvista.com> <20070306084751.b82a7b84.randy.dunlap@oracle.com>
In-Reply-To: <20070306084751.b82a7b84.randy.dunlap@oracle.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Randy Dunlap wrote:
>>     Erm, before I do that, could somebody explain what
>>
>> #define HAVE_PCI_REQ_REGIONS 2
>>
>> accompanying their declaration is for? I have't found any references to it in 
>> the source. Should I duplicate it for CONFIG_PCI=n case (I guess not)?
> 
> I wouldn't since it's not used anywhere, but maybe Tejun could comment
> on it...

This is the first time I see that macro.  There is no user in the whole
source.  I think the best way is to just kill it.

Thanks.

-- 
tejun
