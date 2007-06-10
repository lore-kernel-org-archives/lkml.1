Return-Path: <linux-kernel-owner+w=401wt.eu-S1755568AbXFJLI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568AbXFJLI2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 07:08:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753352AbXFJLIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 07:08:20 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:22352 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256AbXFJLIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 07:08:19 -0400
Date: Sun, 10 Jun 2007 13:08:18 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Simon Arlott <simon@fire.lp0.eu>
cc: Tarkan Erimer <tarkan@netone.net.tr>, davids@webmaster.com,
       linux-kernel@vger.kernel.org, neilb@suse.de
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
In-Reply-To: <466BC18F.9090202@simon.arlott.org.uk>
Message-ID: <Pine.LNX.4.64.0706101307060.8723@fbirervta.pbzchgretzou.qr>
References: <MDEHLPKNGKAHNMBLJOLKAEFCEHAC.davids@webmaster.com>
 <466BB85B.6050703@netone.net.tr> <466BC18F.9090202@simon.arlott.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 10 2007 10:17, Simon Arlott wrote:
>On 10/06/07 09:37, Tarkan Erimer wrote:
>> BTW,I found a really interesting blog entry about which code in Linux
>> Kernel is using which version of GPL :
>> 
>> http://6thsenseless.blogspot.com/2007/02/how-much-linux-kernel-code-is-gpl-2.html
>> 
>> You've got to take MODULE_LICENSE() into account. There is
>> 
>> 	MODULE_LICENSE("GPL");
>> 	MODULE_LICENSE("GPL v2");
>> 	MODULE_LICENSE("GPL and additional rights");
>> 	MODULE_LICENSE("Dual BSD/GPL");
>> 	MODULE_LICENSE("Dual MIT/GPL");
>> 	MODULE_LICENSE("Dual MPL/GPL");
>
>Surely that doesn't work since the entire Linux kernel is (and can only be) 
>released as GPLv2? Wouldn't anyone making changes to those files need to 
>obtain a copy under the other licence and explicitly release it under both 
>licenses in order to maintain that?

http://www.eweek.com/article2/0,1759,1915720,00.asp
has the answer. Quoting Linus:

"If you want to license a program under any later version of the GPL, you have
to state so explicitly. Linux never did."

Hence, unless there's a "GPL 2 or later", all the "unspecified GPL" files
are GPL2 only.


	Jan
-- 
