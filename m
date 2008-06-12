Return-Path: <linux-kernel-owner+w=401wt.eu-S1759957AbYFLTjA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759957AbYFLTjA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 15:39:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754631AbYFLTiv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 15:38:51 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:48689 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754603AbYFLTiu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 15:38:50 -0400
From: "Altobelli, David" <david.altobelli@hp.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 12 Jun 2008 19:37:59 +0000
Subject: RE: [PATCH] HP iLO driver
Thread-Topic: [PATCH] HP iLO driver
Thread-Index: AcjMu2uVHUekpfHuQQi8CZefLtSH3wABReGg
Message-ID: <CF70AA892F109448AEA269483B3A983903B6F79CCA@G1W1215.americas.hpqcorp.net>
References: <20080612182308.GA1091@ldl.fc.hp.com> <48516CF2.106@zytor.com>
In-Reply-To: <48516CF2.106@zytor.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> David Altobelli wrote:
>> A driver for the HP iLO/iLO2 management processor, which allows
>> userspace programs to query the management processor.  Programs can
>> open a channel to the device (/dev/hpilo_ccbN), and use this to
>> send/receive queries. The O_EXCL open flag is used to indicate that
>> a particular channel cannot be shared between processes.  This
>> driver will replace various packages HP has shipped, including hprsm
>> and hp-ilo.
>
> Wouldn't /dev/hpilo/ccbN be a more appropriate namespace?

Yes, that would be more clear.  The code is currently defined to a maximum of 1 hardware device, but this could change, and the dev path should probably reflect that.

How do you feel about /dev/hpiloX/ccbN, where X is 0, 1, ... Num_Devices-1?
