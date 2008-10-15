Return-Path: <linux-kernel-owner+w=401wt.eu-S1755574AbYJOTRx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574AbYJOTRx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 15:17:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753113AbYJOTRn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 15:17:43 -0400
Received: from smtp6-g19.free.fr ([212.27.42.36]:35747 "EHLO smtp6-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752306AbYJOTRm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 15:17:42 -0400
Message-ID: <48F641A3.5080609@free.fr>
Date: Wed, 15 Oct 2008 21:16:51 +0200
From: matthieu castet <castet.matthieu@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.17) Gecko/20080829 Iceape/1.1.12 (Debian-1.1.12-1)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: David Greaves <david@dgreaves.com>, linux-ide@vger.kernel.org,
       Smartmontools Mailing List 
	<smartmontools-support@lists.sourceforge.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [smartmontools-support] SMART to USB/sata dock in 2.6.27-rc5
 doesn't work
References: <48EE7E0A.8040701@dgreaves.com> <48F40164.5000502@kernel.org>
In-Reply-To: <48F40164.5000502@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Tejun Heo wrote:
> David Greaves wrote:
>> Error Counter logging not supported
>> Device does not support Self Test logging
> 
> The USB bridge should support SAT (SCSI-ATA translation) and many
> don't.  Nothing much can be done about it.  The hardware just don't know
> how to do it.
> 
That true that the hardware should support SAT, but even if it support 
it, linux need some patches to support SAT over USB. See 
http://thread.gmane.org/gmane.linux.scsi/43688 and the patch mentioned 
in the thread.

Unfortunately I am a bit busy to try to resubmit it. But I won't care if 
somebody improve it/resubmit it ;)

Matthieu

PS : there also  http://thread.gmane.org/gmane.linux.usb.general/7145 
that is pending.


