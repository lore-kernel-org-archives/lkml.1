Return-Path: <linux-kernel-owner+w=401wt.eu-S1752632AbZKOMDL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632AbZKOMDL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 07:03:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752256AbZKOMDL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 07:03:11 -0500
Received: from smtp1.extricom.com ([212.235.17.194]:52770 "HELO
	smtp.extricom.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with SMTP id S1752164AbZKOMDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 07:03:10 -0500
X-Greylist: delayed 1204 seconds by postgrey-1.27 at vger.kernel.org; Sun, 15 Nov 2009 07:03:09 EST
Message-ID: <4AFFE7B1.2010908@extricom.com>
Date: Sun, 15 Nov 2009 13:36:17 +0200
From: Eran Liberty <liberty@extricom.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] serial_core: avoid Break bouncing
References: <20091112140504.6daf3824@pedra.chehab.org>	<20091112175649.145cbf18@lxorguk.ukuu.org.uk>	<20091112162120.45b33ecf@pedra.chehab.org> <20091112200212.0f2d1e40@lxorguk.ukuu.org.uk>
In-Reply-To: <20091112200212.0f2d1e40@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> I'll do a deeper analysis and come back with a patch only if I discover
>> something new about this issue.
>>     
>
> I'll forward you the end of the previous discussion
>   

Tried, unsuccessfully , to dig up the end of the original thread. In the 
end my patch was deemed unworthy for:
1. Creating a security whole. I am not a security expert so I just 
accepted it as is.
2. Trying to fix something that is not broken. i.e. multiple entry to 
uart_handle_break() upon break trigger is a localized problem to my 
hardware.

If something changed and you need my help I will be more then happy to 
extend it.

-- Liberty
