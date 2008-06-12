Return-Path: <linux-kernel-owner+w=401wt.eu-S1759412AbYFLVGF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759412AbYFLVGF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 17:06:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755935AbYFLVFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 17:05:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41348 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755830AbYFLVFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 17:05:40 -0400
Message-ID: <48518F99.7060003@zytor.com>
Date: Thu, 12 Jun 2008 14:05:29 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Altobelli, David" <david.altobelli@hp.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] HP iLO driver
References: <20080612182308.GA1091@ldl.fc.hp.com> <48516CF2.106@zytor.com> <CF70AA892F109448AEA269483B3A983903B6F79CCA@G1W1215.americas.hpqcorp.net>
In-Reply-To: <CF70AA892F109448AEA269483B3A983903B6F79CCA@G1W1215.americas.hpqcorp.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Altobelli, David wrote:
>> Wouldn't /dev/hpilo/ccbN be a more appropriate namespace?
> 
> Yes, that would be more clear.  The code is currently defined to a maximum of 1 hardware device, but this could change, and the dev path should probably reflect that.
> 
> How do you feel about /dev/hpiloX/ccbN, where X is 0, 1, ... Num_Devices-1?

I'd rather see /dev/hpilo/dXcY, the point being to try to declutter the 
/dev root.

	-hpa
