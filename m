Return-Path: <linux-kernel-owner+w=401wt.eu-S1751801AbXBRSLy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751801AbXBRSLy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 13:11:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751806AbXBRSLy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 13:11:54 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:17176 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801AbXBRSLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 13:11:53 -0500
Date: Sun, 18 Feb 2007 10:06:44 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jean Delvare <khali@linux-fr.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Dax Kelson <dax@gurulabs.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Linus' laptop and Num lock status
Message-Id: <20070218100644.e7c40a88.randy.dunlap@oracle.com>
In-Reply-To: <45D88D9F.7090705@zytor.com>
References: <1171479361.3706.48.camel@mentorng.gurulabs.com>
	<Pine.LNX.4.64.0702141104210.3604@woody.linux-foundation.org>
	<20070214202144.1ddb930f.khali@linux-fr.org>
	<45D46F7B.3060105@zytor.com>
	<20070218170401.286e0fc6.khali@linux-fr.org>
	<45D88D9F.7090705@zytor.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 Feb 2007 09:32:15 -0800 H. Peter Anvin wrote:

> Jean Delvare wrote:
> > On Thu, 15 Feb 2007 06:34:35 -0800, H. Peter Anvin wrote:
> >> Jean Delvare wrote:
> >>> On x86, the BIOS led state can be read from byte 0x97 the BIOS RAM. The
> >>> BIOS RAM is mapped at 0x400 so all we need to do is to one byte from
> >>> RAM (offset 0x497). This is how Suse's hwinfo does.
> >> Perhaps that's what Suse does, but the proper address is 0x417.
> >>
> >> 0x497 is the rarely-used LPT2 timeout counter.
> > 
> > Still, the information printed by hwinfo is correct, I've tested it
> > myself. Is there some publicly available documentation about the x86
> > BIOS RAM mapping?
> > 
> 
> Google for Ralf Brown's Interrupt List.

(Ralph)

I didn't find the BIOS data areas/tables in Ralph's web pages...

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
