Return-Path: <linux-kernel-owner+w=401wt.eu-S1755429AbYLOT0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429AbYLOT0n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 14:26:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751772AbYLOT0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 14:26:34 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:48033 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbYLOT0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 14:26:33 -0500
Message-ID: <4946AF6A.8030107@oracle.com>
Date: Mon, 15 Dec 2008 11:26:34 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       sameo@openedhand.com
Subject: Re: linux-next: Tree for December 15 (mfd)
References: <20081216020642.fc1007d9.sfr@canb.auug.org.au>
In-Reply-To: <20081216020642.fc1007d9.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt700.oracle.com [141.146.40.70]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4946AF60.00E7:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lots of mfd build failures like this:


build-r7123.out:/local/linsrc/linux-next-20081215/drivers/mfd/twl4030-irq.c:183: error: 'irq_desc' undeclared (first use in this function)
build-r7123.out:/local/linsrc/linux-next-20081215/drivers/mfd/twl4030-irq.c:455: error: 'irq_desc' undeclared (first use in this function)
build-r7123.out:/local/linsrc/linux-next-20081215/drivers/mfd/twl4030-irq.c:515: error: 'irq_desc' undeclared (first use in this function)
build-r7123.out:make[3]: *** [drivers/mfd/twl4030-irq.o] Error 1


~Randy
