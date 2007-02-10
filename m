Return-Path: <linux-kernel-owner+w=401wt.eu-S1752714AbXBJHQJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714AbXBJHQJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 02:16:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752716AbXBJHQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 02:16:08 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:48358 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714AbXBJHQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 02:16:07 -0500
Subject: Re: NAK new drivers without proper power management?
From: Arjan van de Ven <arjan@infradead.org>
To: nigel@nigel.suspend2.net
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1171059968.1484.90.camel@nigel.suspend2.net>
References: <1171058269.1484.64.camel@nigel.suspend2.net>
	 <1171059433.8675.195.camel@laptopd505.fenrus.org>
	 <1171059968.1484.90.camel@nigel.suspend2.net>
Content-Type: text/plain
Organization: Intel International BV
Date: Sat, 10 Feb 2007 08:15:49 +0100
Message-Id: <1171091749.8675.250.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > 
> > to a large degree, a device driver that doesn't suspend is better than
> > no device driver at all, right?
> 
> I'm not sure it is. It only makes more work for everyone else: We have
> to help people figure out what causes their computer to fail to resume
> (which can take quite a while), 

so we make the kernel printk on suspend if there are devices without
suspend/resume. Heck, make a config option that prints that at modprobe
time.


-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

