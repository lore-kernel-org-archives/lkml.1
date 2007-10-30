Return-Path: <linux-kernel-owner+w=401wt.eu-S1758167AbXJ3UDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758167AbXJ3UDx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 16:03:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753810AbXJ3UDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 16:03:46 -0400
Received: from az33egw01.freescale.net ([192.88.158.102]:44198 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177AbXJ3UDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 16:03:45 -0400
Message-ID: <47278DB8.7000401@freescale.com>
Date: Tue, 30 Oct 2007 15:02:00 -0500
From: Timur Tabi <timur@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.6) Gecko/20070802 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Zach Brown <zach.brown@oracle.com>
CC: apw@shadowen.org, linux-kernel@vger.kernel.org
Subject: Re: checkpatch bug: space between left parenthesis and asterisk
References: <47278591.90305@freescale.com> <47278BE8.6010901@oracle.com>
In-Reply-To: <47278BE8.6010901@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zach Brown wrote:
> Timur Tabi wrote:
>> I'm running checkpatch.pl (dated 10/17), and it complains about this line:
>>
>> crc = __be32_to_cpu(* ((__be32 *) ((void *) firmware + calc_size)));
> 
> Well, that is a bit of a stinker.  Maybe it could be reworked a little
> to make it easier for humans and checkpatch to understand?
> 
>   __be32 *crazy_pointer = (void *)firmware + calc_size;
>   crc = be32_to_cpu(*crazy_pointer);

I admit the code might be convoluted, but it's perfectly valid, and it 
eliminates the need for "crazy_pointer".  I'm much more inclined to ignore
the checkpatch error than to redesign my code.

Besides, your argument is a bit of a strawman.  The real problem is with checkpatch.

> (Does this need to worry about get_unaligned() at all?)

Well, I suppose it's technically possible, but only if my data has been corrupted.

-- 
Timur Tabi
Linux kernel developer at Freescale
