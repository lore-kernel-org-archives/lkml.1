Return-Path: <linux-kernel-owner+w=401wt.eu-S1760306AbXGCL40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760306AbXGCL40 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 07:56:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760159AbXGCL4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 07:56:08 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:55144 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760137AbXGCL4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 07:56:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=X62nBSflrg+Y8qNApC/Y3FlPztTVJ64kDJY7VxM+v1Z1nCgVm3L6LSFOL5hHJzF+19g49f/7fu6UYVEBv6Sta/AoP9FGSxDNUbuZW9MIczO5rEiDgT5UkLJeqzAApKl7GWzaT6e3euhcWyCNhYZr5pNDalA+tZoAlJSl/Audeh4=
Message-ID: <468A3950.8020804@gmail.com>
Date: Tue, 03 Jul 2007 20:56:00 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: William Thompson <wt@electro-mechanical.com>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: Error in syslog on 2.6.20
References: <20070622184018.GA20301@electro-mechanical.com> <4689FA27.6040706@gmail.com> <20070703113945.GK24385@electro-mechanical.com>
In-Reply-To: <20070703113945.GK24385@electro-mechanical.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

William Thompson wrote:
>> Your cd rom failed to complete the TUR command your program issued in
>> the specified timeout.  ODDs sometimes take quite long to finish TUR or
>> any other command when media is changed.  Did you use sg command or
>> cdrom ioctl?
> 
> I'm using SG_IO.  I also tested sg3-utils' sg_tur which gave me the same
> thing.  Is it just a crappy cdrom?

Not necessarily.  It could be just that you're specifying too short
timeout.  Give a shot at longer timeout.

-- 
tejun
