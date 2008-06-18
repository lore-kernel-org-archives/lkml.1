Return-Path: <linux-kernel-owner+w=401wt.eu-S1760180AbYFRALE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760180AbYFRALE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 20:11:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756775AbYFRAKv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 20:10:51 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:36897 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756129AbYFRAKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 20:10:51 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <48585282.4020508@s5r6.in-berlin.de>
Date: Wed, 18 Jun 2008 02:10:42 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.13) Gecko/20080614 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Johannes Stezenbach <js@sig21.net>
CC: Tim Bird <tim.bird@am.sony.com>, Josh Boyer <jwboyer@gmail.com>,
       =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@logfs.org>,
       linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: Recommendation for activating a deferred module init in the	kernel
References: <48580116.9070504@am.sony.com> <20080617190750.GA31224@logfs.org> <485815F6.20507@am.sony.com> <485816B3.3080800@am.sony.com> <20080617202318.GC31224@logfs.org> <20080617163516.2be96400@vader.jdub.homelinux.org> <48583F3B.1090705@s5r6.in-berlin.de> <20080618000306.GA25466@linuxtv.org>
In-Reply-To: <20080618000306.GA25466@linuxtv.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Stezenbach wrote:
> I think the USB bus enumeration can take significant time:
> recognize a device is connected, turn on bus power, try
> to read descriptors (bus powered devices might be slow to
> respond after power up). And this will happen even with
> drivers_autoprobe == 0, right?

Probably... I don't know which particular steps happen in the USB core 
before upper layer drivers are bound.  Not binding the [eou]hci-hcd PCI 
driver would certainly be more effective.
-- 
Stefan Richter
-=====-==--- -==- =--=-
http://arcgraph.de/sr/
