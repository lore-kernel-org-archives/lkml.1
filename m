Return-Path: <linux-kernel-owner+w=401wt.eu-S1761007AbZLKKu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761007AbZLKKu7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 05:50:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760941AbZLKKuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 05:50:55 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:62932 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760928AbZLKKuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 05:50:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Oosu1LUjLZeyI5M9W0Nxwn44Jt1P7q9inWCfo92YKnvL9dwHTAaeEimXVNMGgzX0CD
         zxA7LpCN7wJKrBZmSlmVzeNJSON4tgokjPlQCdqv9HSJNZkKG2iA3RvDZtqB63eglH7B
         B/klQKvuZnu9MHv6zp3+rK/rAu/2rrCOx0q8I=
Message-ID: <4B222426.8000904@gmail.com>
Date: Fri, 11 Dec 2009 11:51:18 +0100
From: Jes Sorensen <jes.sorensen@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Alan Jenkins <sourcejedi.lkml@googlemail.com>
CC: linux-acpi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       lenb@kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: PATCH: Toshiba Bluetooth enabler (v3)
References: <4B192D08.9080608@gmail.com>	 <9b2b86520912080205x478b47eek2377dacdbe44a522@mail.gmail.com>	 <4B1E85A9.3030005@gmail.com>	 <9b2b86520912090517l458bc21cobbb138d460e11f53@mail.gmail.com>	 <4B211346.2000205@gmail.com> <9b2b86520912100900p5796bc35q702af615d3f27a0c@mail.gmail.com>
In-Reply-To: <9b2b86520912100900p5796bc35q702af615d3f27a0c@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/09 18:00, Alan Jenkins wrote:
> I did question "depends on RFKILL".  If you manually configure a
> kernel, you will miss "If you have a modern Toshiba laptop with a
> Bluetooth and an RFKill switch (such as the Portege R500), say Y."
> unless you enable RFKILL first.  (Which is unnecessary since the
> driver will work exactly the same with RFKILL=n).  I wouldn't call it
> a strong objection, but it would be nice to hear the reason you
> included this dependency.
>
> Everything else looks fine.  Thanks for working on this.
> Alan

The driver is acting as RFKill functionality, even if it doesn't
provide it in full. We can pull that depend if you like, however
I still think it's awkward to offer a driver for a functionality
the user had previously said no to.

Cheers,
Jes


