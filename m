Return-Path: <linux-kernel-owner+w=401wt.eu-S936495AbXG0Ku2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936495AbXG0Ku2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 06:50:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759681AbXG0KuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 06:50:18 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:45973 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958AbXG0KuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 06:50:17 -0400
Date: Fri, 27 Jul 2007 12:50:13 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Al Viro <viro@ftp.linux.org.uk>
cc: Yoann Padioleau <padator@wanadoo.fr>, kernel-janitors@vger.kernel.org,
       rmk@arm.linux.org.uk, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/68] 0 -> NULL, for arch/arm
In-Reply-To: <20070727095905.GU27237@ftp.linux.org.uk>
Message-ID: <Pine.LNX.4.64.0707271250020.12711@fbirervta.pbzchgretzou.qr>
References: <200707270944.LAA17082@ifs.emn.fr> <20070727095905.GU27237@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 27 2007 10:59, Al Viro wrote:
>On Fri, Jul 27, 2007 at 11:44:07AM +0200, Yoann Padioleau wrote:
>>  		buf = alloc_safe_buffer(device_info, ptr, size, dir);
>> -		if (buf == 0) {
>> +		if (buf == NULL) {
>
>		if (!buf)
>surely...

Makes it look like it's used as a bool.


	Jan
-- 
