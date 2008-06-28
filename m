Return-Path: <linux-kernel-owner+w=401wt.eu-S1753252AbYF1IGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252AbYF1IGQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 04:06:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751573AbYF1IFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 04:05:51 -0400
Received: from smtp.fullrate.dk ([89.150.129.5]:53493 "EHLO dns2.fullrate.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750971AbYF1IFs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 04:05:48 -0400
Message-ID: <4865F0DA.2050906@agner.org>
Date: Sat, 28 Jun 2008 10:05:46 +0200
From: Agner Fog <agner@agner.org>
Organization: agner@agner.org
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: ABI change for device drivers using future AVX instruction set
References: <48626514.2040905@agner.org>	<20080625092224.736c2541@infradead.org>	<4862ECAB.1040402@zytor.com>	<4864CFA5.9050901@agner.org> <20080627072231.7337ba18@infradead.org>
In-Reply-To: <20080627072231.7337ba18@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
 >the good news is that we review drivers before they get included and 
we do catch such things.

Are you saying that some group should have the monopoly of approving 
device drivers? That is exectly the policy that Microsoft has been so 
much criticized for. You can only control the drivers that are included 
in your own Linux distribution.

Nothing should prevent me from publishing my own driver for some special 
purpose (in fact, I am going to do so). The open source principle would 
allow anybody to make a different compiler for device drivers, possibly 
using a different programming language. Or making a function library for 
use in device drivers.

Thank you for the reference to DocBook/kernel-hacking. The title reads 
"Unreliable Guide To Hacking The Linux Kernel". This doesn't really look 
like the place to look for authoritative information. It warns against 
using floating point/MMX, but not XMM. You can't blame programmers for 
making faulty device drivers when there is no authoritative guideline to 
follow.

You don't seem to realize the importance of proper documentation. Do you 
want me to write in my manual: "There is no authoritative information on 
this, but the Linux Junta says so-and-so.."?

How can you expect people to regard Linux as a serious and reliable 
alternative to ..BEEP.. when there is no proper documentation?

It is a disgrace that the ABI consists of fractions stored in weird 
places and some of them still drafts, but at least there is consensus on 
which one to look in for authoritative information. There should be an 
authoritative document on what you can do and not do in a device driver, 
and the ABI would be the most natural place to put this information. It 
is important to tell people that they can save and restore an XMM 
register under certain conditions, but not a YMM register. You can't 
expect people to search through a huge mailing list archive for such 
information.


Note: Please Cc: me of answers
