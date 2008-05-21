Return-Path: <linux-kernel-owner+w=401wt.eu-S1765527AbYEUW5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765527AbYEUW5Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 18:57:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756976AbYEUW5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 18:57:17 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:53558 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755238AbYEUW5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 18:57:16 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4834A896.3040702@s5r6.in-berlin.de>
Date: Thu, 22 May 2008 00:56:22 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.13) Gecko/20080419 SeaMonkey/1.1.9
MIME-Version: 1.0
To: jszhang3@mail.ustc.edu.cn
CC: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
       krh@redhat.com
Subject: Re: [PATCH] firewire: fix some broken hardware NMI interrupt
References: <411375292.14780@ustc.edu.cn> <48343F99.4030803@s5r6.in-berlin.de>
In-Reply-To: <48343F99.4030803@s5r6.in-berlin.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> jszhang3@mail.ustc.edu.cn wrote:
>> Some broken pci-1394 card does not clear completely on-chip memory during boot, it
>> may cause pci parity error, then NMI interrupt.
> 
> Which card?
> 
> Is the problem still present in linux-2.6.26-rc3?
> 
> Or if you don't want to test 2.6.26-rc yet, please test 2.6.25.4 with
> the firewire patchkit from
> http://me.in-berlin.de/~s5r6/linux1394/updates/.  There were changes to
> fw-ohci which influence chip initialization.

PS:
And does the parity error happen with the ohci1394 driver too?
-- 
Stefan Richter
-=====-==--- -=-= =-==-
http://arcgraph.de/sr/
