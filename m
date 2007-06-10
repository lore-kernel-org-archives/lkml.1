Return-Path: <linux-kernel-owner+w=401wt.eu-S1752992AbXFJJDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992AbXFJJDj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 05:03:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751796AbXFJJDc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 05:03:32 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:6848 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730AbXFJJDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 05:03:31 -0400
Date: Sun, 10 Jun 2007 11:03:30 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Tarkan Erimer <tarkan@netone.net.tr>
cc: davids@webmaster.com, linux-kernel@vger.kernel.org
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
In-Reply-To: <466BB85B.6050703@netone.net.tr>
Message-ID: <Pine.LNX.4.64.0706101058170.8723@fbirervta.pbzchgretzou.qr>
References: <MDEHLPKNGKAHNMBLJOLKAEFCEHAC.davids@webmaster.com>
 <466BB85B.6050703@netone.net.tr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 10 2007 11:37, Tarkan Erimer wrote:
>
> Thanks for the corrections ;-) The whole picture is more clear now for me :-)
> BTW,I found a really interesting blog entry about which code in Linux Kernel is
> using which version of GPL :
>
> http://6thsenseless.blogspot.com/2007/02/how-much-linux-kernel-code-is-gpl-2.html

You've got to take MODULE_LICENSE() into account. There is

	MODULE_LICENSE("GPL");
	MODULE_LICENSE("GPL v2");
	MODULE_LICENSE("GPL and additional rights");
	MODULE_LICENSE("Dual BSD/GPL");
	MODULE_LICENSE("Dual MIT/GPL");
	MODULE_LICENSE("Dual MPL/GPL");

I think it's time to set things right, making

	* MODULE_LICENSE the authoritative place for the license
	  (also makes it easier to grep for)

	* sync up license into MODULE_LICENSE



	Jan
-- 
