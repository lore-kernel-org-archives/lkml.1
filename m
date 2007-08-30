Return-Path: <linux-kernel-owner+w=401wt.eu-S1760249AbXH3QPK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760249AbXH3QPK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 12:15:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757272AbXH3QO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 12:14:59 -0400
Received: from 85-10-209-111.clients.your-server.de ([85.10.209.111]:55479
	"EHLO mail.road.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755241AbXH3QO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 12:14:59 -0400
X-Greylist: delayed 491 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Aug 2007 12:14:58 EDT
From: Uli Luckas <u.luckas@road.de>
Organization: Road GmbH
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: parse_tag_ramdisk
Date: Thu, 30 Aug 2007 18:06:41 +0200
User-Agent: KMail/1.9.7
Cc: "Xu Yang" <risingsunxy@googlemail.com>
References: <ab40e9c0708300707r2e6d2d71y42940084db5038ac@mail.gmail.com>
In-Reply-To: <ab40e9c0708300707r2e6d2d71y42940084db5038ac@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708301806.42905.u.luckas@road.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 30. August 2007, Xu Yang wrote:
> Hi guys,
>
>
> I found that in the function parse_tag_ramdisk , the setup_ramdisk is
> called. is it true that in the setup_ramdisk the location ot the
> initrd is specified?
>
> it seems that in my case the parse_tag_ramdisk is never accessed. what
> might cause this?
>
Hi Xu, 
I didn't get down to completely debugging this problem. But for no obvious 
reason, parsing seems to ends after it hits a command line tag. 
Try putting the command line tag last in the tag list and see if that helps.

Regards
Uli

-- 

------- ROAD ...the handyPC Company - - -  ) ) )

Uli Luckas
Software Development

ROAD GmbH
Bennigsenstr. 14 | 12159 Berlin | Germany
fon: +49 (30) 230069 - 64 | fax: +49 (30) 230069 - 69
url: www.road.de

Amtsgericht Charlottenburg: HRB 96688 B
Managing directors: Hans-Peter Constien, Hubertus von Streit
