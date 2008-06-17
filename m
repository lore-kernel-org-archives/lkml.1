Return-Path: <linux-kernel-owner+w=401wt.eu-S1757198AbYFQT4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198AbYFQT4b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 15:56:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754252AbYFQT4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 15:56:22 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:23172 "EHLO
	VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213AbYFQT4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 15:56:21 -0400
X-BigFish: VPS-24(zz1432R98dR1805Mzz10d3izzz2fh6bh62h)
X-Spam-TCS-SCL: 1:0
Message-ID: <485816B3.3080800@am.sony.com>
Date: Tue, 17 Jun 2008 12:55:31 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>
CC: linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: Recommendation for activating a deferred module init in the kernel
References: <48580116.9070504@am.sony.com> <20080617190750.GA31224@logfs.org> <485815F6.20507@am.sony.com>
In-Reply-To: <485815F6.20507@am.sony.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Jun 2008 19:56:04.0813 (UTC) FILETIME=[2D062FD0:01C8D0B4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tim Bird wrote:
>> If you want an explicit trigger, you could either hook into init_post()
>> or have hooks in the open functions of drivers with deferred
>> initialization.
> 
> This would presumably require multiple calls (one to the open of
> each deferred module).  I would still need a trigger for the memory
> free operation, unless I hardcode the order of the opening and just
> "know" that the last one should free the memory.  I'll have to see
> if all the modules being loaded like this have open()s.

Sorry - I responded too quickly.  I'm not sure I follow the
original suggestion.  How would I call the open function of
a module that is not initialized yet?
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

