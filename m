Return-Path: <linux-kernel-owner+w=401wt.eu-S1759451AbYHTPHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759451AbYHTPHd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 11:07:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754589AbYHTPHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 11:07:24 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:2057 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757294AbYHTPHW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 11:07:22 -0400
X-Server-Uuid: 02CED230-5797-4B57-9875-D5D2FEE4708A
From: "Michael Chan" <mchan@broadcom.com>
To: "'Mel Gorman'" <mel@csn.ul.ie>, "Matthew Carlson" <mcarlson@broadcom.com>
cc: "davem@davemloft.net" <davem@davemloft.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 20 Aug 2008 08:06:36 -0700
Subject: Re: Major stalls due to commit
 7c5026aa9b81dd45df8d3f4e0be73e485976a8b6
Thread-Topic: Major stalls due to commit
 7c5026aa9b81dd45df8d3f4e0be73e485976a8b6
Thread-Index: AckCvQJa8aw36r34RpSyI+J54SdW0gAGJsBQ
Message-ID: <C27F8246C663564A84BB7AB343977242024953CE42@IRVEXCHCCR01.corp.ad.broadcom.com>
In-Reply-To: <20080820120501.GC20199@csn.ul.ie>
Accept-Language: en-US
Content-Language: en-US
acceptlanguage: en-US
MIME-Version: 1.0
X-OriginalArrivalTime: 20 Aug 2008 15:06:37.0490 (UTC)
 FILETIME=[57BB0120:01C902D6]
X-WSS-ID: 64B2EC964E0121713501-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman wrote:

> I had the pleasure of getting hold of one of these machines
> http://www.terrasoftsolutions.com/products/powerstation/ and
> after some
> tinkering installed 2.6.27-rc3. However, it was way slower and jerkier
> (keyboard input for example would stop processing for up to 2 seconds)
> than the distribution kernel. Network is a bit useless and
> kernel builds
> went from about 4 minutes to about 12 even when built
> locally. I also noted
> with NO_HZ enabled that a soft-lockup would be reported in a
> timer related
> to tg3. The card in question is
>

This has been fixed a few days ago by the patch:

tg3: Fix firmware event timeouts

in the net-2.6 git tree.  Please try that to see if it fixes
the problem.  Thanks.

