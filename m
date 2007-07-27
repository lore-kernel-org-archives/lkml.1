Return-Path: <linux-kernel-owner+w=401wt.eu-S936891AbXG0MTL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936891AbXG0MTL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 08:19:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760198AbXG0MTA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 08:19:00 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:39001 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758898AbXG0MTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 08:19:00 -0400
Date: Fri, 27 Jul 2007 14:18:59 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Alexey Dobriyan <adobriyan@gmail.com>
cc: Al Viro <viro@ftp.linux.org.uk>, Yoann Padioleau <padator@wanadoo.fr>,
       kernel-janitors@vger.kernel.org, rmk@arm.linux.org.uk,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/68] 0 -> NULL, for arch/arm
In-Reply-To: <b6fcc0a0707270507u1c77e093y30d9bd5bddfa9054@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0707271418390.12711@fbirervta.pbzchgretzou.qr>
References: <200707270944.LAA17082@ifs.emn.fr>  <20070727095905.GU27237@ftp.linux.org.uk>
  <Pine.LNX.4.64.0707271250020.12711@fbirervta.pbzchgretzou.qr>
 <b6fcc0a0707270507u1c77e093y30d9bd5bddfa9054@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 27 2007 16:07, Alexey Dobriyan wrote:
>On 7/27/07, Jan Engelhardt <jengelh@computergmbh.de> wrote:
>> On Jul 27 2007 10:59, Al Viro wrote:
>> >On Fri, Jul 27, 2007 at 11:44:07AM +0200, Yoann Padioleau wrote:
>> >>  		buf = alloc_safe_buffer(device_info, ptr, size, dir);
>> >> -		if (buf == 0) {
>> >> +		if (buf == NULL) {
>> >
>> >		if (!buf)
>> >surely...
>>
>> Makes it look like it's used as a bool.
>
>bool variables are rarely named buf, so no.

Whatever. Java is good in one point: the ! operator requires a bool.


	Jan
-- 
