Return-Path: <linux-kernel-owner+w=401wt.eu-S1755442AbYDXDsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442AbYDXDsv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 23:48:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753736AbYDXDsn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 23:48:43 -0400
Received: from wx-out-0506.google.com ([66.249.82.231]:6953 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724AbYDXDsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 23:48:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=CmleeXFVOFUh5jLRtA1yL4UPcELMJOgyYJ61bhhYWqMdU2uZYZWq6uVS7QtpZPVrwa2NucrpzI2KYfS8yW9Fcp032MqFEe4WbOAO4/HC4I0trJCyseBkR7VainCLwpXu2c87DN1ZwC/lHRAsMwtvVqynAWxHvYOcRC8FBS8NBHQ=
Message-ID: <48100310.3060300@gmail.com>
Date: Thu, 24 Apr 2008 12:48:32 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
CC: Frans Pop <elendil@planet.nl>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: No IDE drivers loaded for Toshiba Satellite 320 CDS
References: <200804021524.27222.elendil@planet.nl> <20080415144748.GO7385@csclub.uwaterloo.ca> <48053AD1.8010007@gmail.com> <200804162008.27655.elendil@planet.nl> <480679D3.7030705@gmail.com> <20080417140506.GC7385@csclub.uwaterloo.ca>
In-Reply-To: <20080417140506.GC7385@csclub.uwaterloo.ca>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lennart Sorensen wrote:
> After all I thought the whole point of all the ports listed in
> /proc/ioports was to indicate which io ports were currently reserved by
> which driver so that no other driver could try to access them.  If it
> doesn't in fact work that way then it probably should.

It does work most of the time and it's probably safe to load legacy / 
generic drivers on most configurations.  It's just that we're talking 
about 15+ years of gap between ISA and PCI-e and there could be some 
exceptions and we might need to tread a bit more carefully.  To me, it 
sounds reasonable.

Thanks.

-- 
tejun
