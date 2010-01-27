Return-Path: <linux-kernel-owner+w=401wt.eu-S1754654Ab0A0CXM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654Ab0A0CXM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 21:23:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753614Ab0A0CXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 21:23:10 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:64529 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753136Ab0A0CXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 21:23:09 -0500
X-Greylist: delayed 579 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Jan 2010 21:23:09 EST
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AngBAJkyX0tLd/sX/2dsb2JhbAAIg0CWXLAnj16BKYEDgTNYBA
X-IronPort-AV: E=Sophos;i="4.49,350,1262581200"; 
   d="scan'208";a="54635632"
Message-ID: <4B5FA38A.5040700@teksavvy.com>
Date: Tue, 26 Jan 2010 21:23:06 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Vishal Rao <vishalrao@gmail.com>
CC: Jeff Garzik <jgarzik@pobox.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       trivial@kernel.org, stable@kernel.org
Subject: Re: [PATCH] ata: Disable NCQ for Crucial M225 brand SSDs
References: <aacba7e1001260704m27c99a0dy6c3f50c38ce6b430@mail.gmail.com>	 <20100126160243.018b87e3@lxorguk.ukuu.org.uk>	 <aacba7e1001260819k24088c81m14b4c702fccddd29@mail.gmail.com>	 <4B5F62C2.4000800@pobox.com> <aacba7e1001261624m4358e4ebwcf8e2305b0c5fc16@mail.gmail.com>
In-Reply-To: <aacba7e1001261624m4358e4ebwcf8e2305b0c5fc16@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vishal Rao wrote:
> 2010/1/27 Jeff Garzik <jgarzik@pobox.com>:
>> On 01/26/2010 11:19 AM, Vishal Rao wrote:
>>> 2010/1/26 Alan Cox<alan@lxorguk.ukuu.org.uk>:
>>>> What controllers did you test with ?
>>> Tested with my own Crucial CT128M225 model which has the IndiLinx
>>> Barefoot controller.
>> By controller, I think Alan meant the host controller (ata_piix, ahci,
>> etc.)?
> 
> Oh I see, I have an Intel DP35DP motherboard with onboard IDE controller
> with AHCI enabled. I hope thats sufficient information for now. I did read
> that simply setting the mode to legacy IDE would disable NCQ there but
> would disable for all drives connected.
> 
> Please let me know if further info/log files (dmesg, lspci etc) would help
> and I will pastebin them...
..

Can you identify the specific Indilinx build number that your drive firmware
is based upon?  If not, then at least post the identify data for us to examine:

   hdparm --Istdout /dev/sd?

-ml
