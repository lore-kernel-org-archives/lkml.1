Return-Path: <linux-kernel-owner+w=401wt.eu-S1757907AbXFDRpe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757907AbXFDRpe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 13:45:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753415AbXFDRp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 13:45:27 -0400
Received: from terminus.zytor.com ([192.83.249.54]:53588 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229AbXFDRp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 13:45:27 -0400
Message-ID: <46644F57.80005@zytor.com>
Date: Mon, 04 Jun 2007 10:43:51 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
CC: Jeff Garzik <jeff@garzik.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Al Viro <viro@ftp.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org
Subject: Re: [RFC] Documentation/CodingStyle: Add rules for goto labels
References: <20070603142450.GA4230@localhost.localdomain> <20070603142939.GW4095@ftp.linux.org.uk> <20070603074552.430c3d02.rdunlap@xenotime.net> <4662DFCF.3010606@garzik.org> <46644B97.2010506@zytor.com> <Pine.LNX.4.61.0706041935290.20829@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0706041935290.20829@yvahk01.tjqt.qr>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Jun 4 2007 10:27, H. Peter Anvin wrote:
>> Jeff Garzik wrote:
>>> Seconded.  All my code contains the goto label in the first column.
>>>
>>> IMO any other goto label indentation is silly, because it obscures the
>>> goto label within the code block.
>> I would have to disagree with this.  IMNSHO, a goto label is like a case
>> label, and they should be treated the same way.
> 
> But gotos are special. ("Evil" minus the "it's good for unrolling in case of an
> error" case).
> 

So?

You still want them to be associated with the level the bailout happens at.

	-hpa
