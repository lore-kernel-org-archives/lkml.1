Return-Path: <linux-kernel-owner+w=401wt.eu-S1754061AbYKOF4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061AbYKOF4i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 00:56:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751889AbYKOF43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 00:56:29 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39964 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751648AbYKOF43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 00:56:29 -0500
Date: Fri, 14 Nov 2008 21:56:07 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David <david@unsolicited.net>
Cc: linux-kernel@vger.kernel.org, video4linux-list@redhat.com
Subject: Re: Regression: USB/DVB 2.6.26.8 --> 2.6.27.6
Message-Id: <20081114215607.dc10a235.akpm@linux-foundation.org>
In-Reply-To: <491DDD98.7090306@unsolicited.net>
References: <491DDD98.7090306@unsolicited.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc video4linux-list@redhat.com)

On Fri, 14 Nov 2008 20:20:40 +0000 David <david@unsolicited.net> wrote:

> I've just tried to upgrade my media server to the latest stable kernel
> and have found problems with my USB DVB  devices. With the new kernel
> I'm seeing
> 
> DVB: registering new adapter (Technotrend TT-connect S-2400)
> DVB: registering frontend 3 (Philips TDA10086 DVB-S)...
> dvb-usb: recv bulk message failed: -110
> ttusb2: there might have been an error during control message transfer.
> (rlen = 0, was 0)
> dvb-usb: Technotrend TT-connect S-2400 successfully initialized and
> connected.
> 
> All of the registered DVB devices are now inoperable. dmesgs from both
> kernels attached. There are subtle differences in the device numbering
> as the devices were in warm state on the second kernel boot (however the
> problem is still present whether the devices are warm or cold).
> 
> Any help will be appreciated
> 

