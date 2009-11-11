Return-Path: <linux-kernel-owner+w=401wt.eu-S1758913AbZKKUr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758913AbZKKUr5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 15:47:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758680AbZKKUr4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 15:47:56 -0500
Received: from zrtps0kp.nortel.com ([47.140.192.56]:48431 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758662AbZKKUr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 15:47:56 -0500
Message-ID: <4AFB2298.5040903@nortel.com>
Date: Wed, 11 Nov 2009 14:46:16 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: x86@kernel.org, linux-kernel@vger.kernel.org,
       Dave Jones <davej@codemonkey.org.uk>
Subject: Re: [PATCH RFC] x86: fix confusing name of /proc/cpuinfo "ht" flag
References: <200911112134.34261.bzolnier@gmail.com>
In-Reply-To: <200911112134.34261.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Nov 2009 20:47:43.0856 (UTC) FILETIME=[37B29F00:01CA6310]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2009 02:34 PM, Bartlomiej Zolnierkiewicz wrote:
> 
> "ht" flag indicates only ability to detect siblings not HT presence itself.
> 
> Inspired by:
> http://www.codemonkey.org.uk/2009/11/10/common-hyperthreading-misconception/
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
> It could be that there are some user-space programs depending on "ht"
> flag so the patch is marked as RFC..

If a cpu is capable of ht but doesn't have any siblings, do we actually
care?

If many people consider the "ht" flag to indicate that hyperthreading is
actually available, what about instead changing the meaning of the "ht"
flag to indicate that there actually are siblings?

Chris

