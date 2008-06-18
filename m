Return-Path: <linux-kernel-owner+w=401wt.eu-S1753016AbYFRJi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016AbYFRJi3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 05:38:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751396AbYFRJiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 05:38:21 -0400
Received: from bar.sig21.net ([88.198.146.85]:52402 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750833AbYFRJiU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 05:38:20 -0400
Date: Wed, 18 Jun 2008 11:38:12 +0200
From: Johannes Stezenbach <js@sig21.net>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Tim Bird <tim.bird@am.sony.com>, Josh Boyer <jwboyer@gmail.com>,
       =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
       linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: Recommendation for activating a deferred module init in the
	kernel
Message-ID: <20080618093812.GB26377@sig21.net>
References: <48580116.9070504@am.sony.com> <20080617190750.GA31224@logfs.org> <485815F6.20507@am.sony.com> <485816B3.3080800@am.sony.com> <20080617202318.GC31224@logfs.org> <20080617163516.2be96400@vader.jdub.homelinux.org> <48583F3B.1090705@s5r6.in-berlin.de> <20080618000306.GA25466@linuxtv.org> <48585282.4020508@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48585282.4020508@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-21-Score: -4.1 (----)
X-Spam-21-Report: No, score=-4.1 required=5.0 tests=ALL_TRUSTED=-1.8,AWL=0.264,BAYES_00=-2.599 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2008, Stefan Richter wrote:
> Johannes Stezenbach wrote:
>> I think the USB bus enumeration can take significant time:
>> recognize a device is connected, turn on bus power, try
>> to read descriptors (bus powered devices might be slow to
>> respond after power up). And this will happen even with
>> drivers_autoprobe == 0, right?
>
> Probably... I don't know which particular steps happen in the USB core  
> before upper layer drivers are bound.  Not binding the [eou]hci-hcd PCI  
> driver would certainly be more effective.

Well, in embedded systems you often don't have a PCI bus,
but platform devices. Maybe it's as simple as delaying
the USB platform_device_register() call, I don't know.

Johannes
