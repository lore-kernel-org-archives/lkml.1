Return-Path: <linux-kernel-owner+w=401wt.eu-S1754744AbYHRTxJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744AbYHRTxJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 15:53:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763491AbYHRTuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 15:50:09 -0400
Received: from main.gmane.org ([80.91.229.2]:44915 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765790AbYHRTuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 15:50:06 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bernd Schubert <bs@q-leap.de>
Subject: Re: Linux 2.6.26 edac errors and ASUS P5W DH Deluxe motherboard
Date: Mon, 18 Aug 2008 21:49:42 +0200
Organization: q-leap networks GmbH
Message-ID: <g8cjom$2bv$1@ger.gmane.org>
References: <0F10A59FDFFDFD4E9BEBD7365DE672550214F027@uk-email.terastack.bluearc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: ns1.q-leap.de
User-Agent: KNode/0.10.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Chittenden wrote:

> I've just installed the linux-image-2.6.26-1-amd64 debian package on
> three of our ASUS P5W DH Deluxe based machines and they've all started
> spewing out messages:
> 
> Message from syslogd@savage at Mon Aug 18 14:01:52 2008 ...
> savage kernel: [   74.389644] EDAC MC0: UE page 0x7fe03, offset 0x0,
> grain 128, row 2, labels ":": i82975x UE
> 
> Message from syslogd@savage at Mon Aug 18 14:01:53 2008 ...
> savage kernel: [   75.555862] EDAC MC0: UE page 0x7fd44, offset 0x0,
> grain 128, row 2, labels ":": i82975x UE
> 
> Message from syslogd@savage at Mon Aug 18 14:01:54 2008 ...
> savage kernel: [   76.628039] EDAC MC0: UE page 0x7fd41, offset 0x0,
> grain 128, row 2, labels ":": i82975x UE
> 
> Message from syslogd@savage at Mon Aug 18 14:01:55 2008 ...
> savage kernel: [   77.629260] EDAC MC0: UE page 0x7fd27, offset 0x0,
> grain 128, row 2, labels ":": i82975x UE
> 
> every second.
> 
> I've removed that kernel package and they're running previous versions
> of the kernel (eg linux-image-2.6.25-2-amd64) happily. I've run memtest
> on one of them with no problems. So, anyone got any ideas what's causing
> this? (FWIW the machines have all got ECC memory in them).
> 

Do have an IPMI card installed in these systems? Know issue here with Asus
boards + IPMI, you then need to disable a few ipmi sensors.


Cheers,
Bernd

