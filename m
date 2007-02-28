Return-Path: <linux-kernel-owner+w=401wt.eu-S1750821AbXB1Rqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750821AbXB1Rqa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 12:46:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750838AbXB1Rqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 12:46:30 -0500
Received: from smtp106.biz.mail.re2.yahoo.com ([206.190.52.175]:43747 "HELO
	smtp106.biz.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750821AbXB1Rq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 12:46:29 -0500
X-YMail-OSG: cyDwNwkVM1nNy1aqMCMNnnvzqbhGIFwg.cAqDWad2lsSwyI5GHHEqq45SerC_OaUVYAxuJ7zWSDnz7VyPHcdtQb59eyDcY7Wwl0zo2lTSmjyup8Rua4a2A4bJppNUBV7iusccXb5Uqz_alY-
In-Reply-To: <45E5BD6B.1010509@freescale.com>
References: <45E46976.6060600@freescale.com>	<29c13109971547687159078eacdea008@kernel.crashing.org>	<45E592DC.9060700@freescale.com>	<511cacb7bbe8a65ff72738c84ec9ece4@kernel.crashing.org>	<BD465924-7387-47EF-B90F-606F215819C2@embeddedalley.com>	<45E5B604.904@freescale.com> <46F6BF70-2922-4E05-8DAB-6B0830B0AB47@embeddedalley.com> <45E5BD6B.1010509@freescale.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <F2D0230C-CA22-4DEF-917E-6982FA0C6171@embeddedalley.com>
Cc: Torben.Mathiasen@hp.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Segher Boessenkool <segher@kernel.crashing.org>,
       linux-ppc-embedded <linuxppc-embedded@ozlabs.org>
Content-Transfer-Encoding: 7bit
From: Dan Malek <dan@embeddedalley.com>
Subject: Re: lanana: Add major/minor entries for PPC QE UART devices
Date: Wed, 28 Feb 2007 12:46:28 -0500
To: Timur Tabi <timur@freescale.com>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 28, 2007, at 12:35 PM, Timur Tabi wrote:

> An alternative idea, which one person already shot down, was to  
> allow only 4 devices normally, but allow more devices if you use  
> udev, since udev doesn't care about minor number assignments.  This  
> eliminates the overlap and encourages people to use udev.

I'd shoot that down, too.  Using udev in an
embedded, reliable environment is very
troublesome.  Although, products I've
developed using more than 4 UARTs had
some custom /dev work done to it just
to get everything mapped.  My only
concern is we don't add a new range for
QE UARTs, that we use the same minors
for both CPM and QE.

Thanks.

	-- Dan

