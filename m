Return-Path: <linux-kernel-owner+w=401wt.eu-S1755453Ab0AZXyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453Ab0AZXyo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 18:54:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754577Ab0AZXyc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:54:32 -0500
Received: from zrtps0kp.nortel.com ([47.140.192.56]:60308 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755420Ab0AZXxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:53:55 -0500
Message-ID: <4B5F7F53.8060002@nortel.com>
Date: Tue, 26 Jan 2010 17:48:35 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: which fields in /proc/meminfo are orthogonal?
References: <4B5F3C9C.3050908@nortel.com> <4B5F54DE.7030302@nortel.com>
In-Reply-To: <4B5F54DE.7030302@nortel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Jan 2010 23:53:36.0757 (UTC) FILETIME=[C6BD4250:01CA9EE2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26/2010 02:47 PM, Chris Friesen wrote:

> I've tried adding up
> MemFree+Buffers+Cached+AnonPages+Mapped+Slab+PageTables+VmallocUsed
> 
> (hugepages are disabled and there is no swap)
> 
> Shortly after boot this gets me within about 3MB of MemTotal.  However,
> after 1070 minutes there is a 64MB difference between MemTotal and the
> above sum.

Oddly enough, over the same period it appears that

MemFree + Active + Inactive + Slab + PageTables

is basically (+/- half a meg) constant and equal to "MemTotal - 48.5MB".


It would seem that active/inactive track memory that isn't visible in
Buffers+Cached+AnonPages+Mapped.  Anyone have any suggestions what it
might be?

Thanks,

Chris
