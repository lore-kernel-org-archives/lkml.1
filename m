Return-Path: <linux-kernel-owner+w=401wt.eu-S1754278AbYJWJBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754278AbYJWJBs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 05:01:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752006AbYJWJBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 05:01:40 -0400
Received: from cluster-g.mailcontrol.com ([208.87.233.190]:45835 "EHLO
	cluster-g.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826AbYJWJBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 05:01:39 -0400
Message-ID: <49003D45.4080708@csr.com>
Date: Thu, 23 Oct 2008 10:00:53 +0100
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: sylaw@i2r.a-star.edu.sg
CC: Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: UWB, WUSB, and WLP subsystems for 2.6.28
References: <fa.s78bJIT7sRB89tYmSVZWUEBUq5k@ifi.uio.no> <6f3df9eb-5c1a-4ee1-a78f-7c0ff55a42fc@t18g2000prt.googlegroups.com>
In-Reply-To: <6f3df9eb-5c1a-4ee1-a78f-7c0ff55a42fc@t18g2000prt.googlegroups.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Oct 2008 09:00:53.0675 (UTC) FILETIME=[DAA28FB0:01C934ED]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sylaw@i2r.a-star.edu.sg wrote:
> 
>   I am currently working on trying to WUSB linux to work on DLINK
> dub1210 dongle. Does the 2.6.26-rc8 of WUSB UWB linux work with
> DUB1210, as when i try to connect to the DLINK UWB Hub it show me
> error when it try to enumerate the hub i believe. Your help is greatly
> appreciated ! thx in advance !

The WUSB hub (DWA) won't do anything useful because there's no DWA
driver.  However, you should be able to authenticate and enumerate it.

Could you expand on the error messages?  It may be useful to build the
driver with additional debugging.

David
-- 
David Vrabel, Senior Software Engineer, Drivers
CSR, Churchill House, Cambridge Business Park,  Tel: +44 (0)1223 692562
Cowley Road, Cambridge, CB4 0WZ                 http://www.csr.com/
