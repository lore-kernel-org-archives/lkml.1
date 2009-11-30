Return-Path: <linux-kernel-owner+w=401wt.eu-S1753446AbZK3LG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446AbZK3LG1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 06:06:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752362AbZK3LG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 06:06:26 -0500
Received: from hera.kernel.org ([140.211.167.34]:47339 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751249AbZK3LG0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 06:06:26 -0500
Message-ID: <4B13A71E.2070803@kernel.org>
Date: Mon, 30 Nov 2009 20:06:06 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Johannes Stezenbach <js@sig21.net>
CC: Greg KH <greg@kroah.com>, Robert Hancock <hancockrwd@gmail.com>,
       Mikhail Malygin <mmalygin@ked.de>, Hans Werner <hwerner4@gmx.de>,
       Thomas Renninger <trenn@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: Samsung N130 ATA exception after 5min uptime -- Phoenix FailSafe
 issue?
References: <20091126164212.GA24421@sig21.net> <20091128191932.GB24048@kroah.com> <4B11886E.3030906@gmail.com> <20091128213446.GA26420@kroah.com> <20091128222203.GA369@sig21.net> <20091129001745.GA29143@kroah.com> <20091129005157.GA6487@sig21.net> <4B1387EB.2090506@kernel.org> <20091130102104.GA13288@sig21.net>
In-Reply-To: <20091130102104.GA13288@sig21.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 11/30/2009 07:21 PM, Johannes Stezenbach wrote:
> I've booted with rdinit=/bin/sh (busybox sh in initramfs), so
> nothing accesses the disk.  After 5min the C state switch
> happens, but no ATA exception. I waited a few more miniutes
> and then used dd if=/dev/sda of=/dev/null  -> ATA exception.
> There is no way to escape it.

Ah, okay, so whatever follows the switch times out.

I have no idea what to do about it at this point.  :-(

-- 
tejun
