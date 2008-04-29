Return-Path: <linux-kernel-owner+w=401wt.eu-S1758921AbYD2SRn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758921AbYD2SRn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 14:17:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756828AbYD2SRb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 14:17:31 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:47704 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756772AbYD2SRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 14:17:31 -0400
Date: Tue, 29 Apr 2008 20:17:26 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: adaplas@gmail.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, hpa@zytor.com
Subject: Re: [PATCH] vt: fix background color on line feed
In-Reply-To: <alpine.LNX.1.10.0804280835370.20150@fbirervta.pbzchgretzou.qr>
Message-ID: <alpine.LNX.1.10.0804292014130.21466@fbirervta.pbzchgretzou.qr>
References: <alpine.LNX.1.10.0804270257270.20150@fbirervta.pbzchgretzou.qr> <20080427193616.9a9cdf85.akpm@linux-foundation.org> <alpine.LNX.1.10.0804280835370.20150@fbirervta.pbzchgretzou.qr>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Monday 2008-04-28 08:46, Jan Engelhardt wrote:
>On Monday 2008-04-28 04:36, Andrew Morton wrote:
>>> commit c5180a555ced08a7e3011c16ef796e47569ae907
>>> Author: Jan Engelhardt <jengelh@computergmbh.de>
>>> Date:   Thu Apr 24 22:40:24 2008 +0200
>>> 
>>> vt: fix background color on line feed
>>>     
>>> A command that causes a line feed while a background color is active,
>>> such as
>>>     
>>> 	perl -e 'print "x" x 60, "\e[44m", "x" x 40, "\e[0m\n"'
>>> and
>>> 	perl -e 'print "x" x 40, "\e[44m\n", "x" x 40, "\e[0m\n"'
>>>     
>>> causes the line that was started as a result of the line feed to be
>>> completely filled with the currently active background color instead
>>> of the default color.
>>
>>Thanks.
>>
>>It would be better if the the changelog were to also describe the cause of
>>the bug, and how the patch fixes it.
>>
>Please append:
>[...]

I think your mailer has whitespace problems -- all whitespaces
got replaced by two, even intrasentence after an "e.g."  :-P
