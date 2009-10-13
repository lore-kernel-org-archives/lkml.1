Return-Path: <linux-kernel-owner+w=401wt.eu-S1759893AbZJMN06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759893AbZJMN06 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 09:26:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759785AbZJMN05
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 09:26:57 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:33329
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759784AbZJMN05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 09:26:57 -0400
Message-ID: <4AD47FC2.9060303@microgate.com>
Date: Tue, 13 Oct 2009 08:25:22 -0500
From: Paul Fulghum <paulkf@microgate.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Linus Torvalds <torvalds@linux-foundation.org>, Nix <nix@esperi.org.uk>,
       "Justin P. Mattock" <justinmattock@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Boyan <btanastasov@yahoo.co.uk>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>, Ed Tomlinson <edt@aei.ca>,
       =?ISO-8859-1?Q?=22Fr=E9d=E9ric_L=2E_W=2E_?=
	 =?ISO-8859-1?Q?Meunier=22?= <fredlwm@gmail.com>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [Bug #14388] keyboard under X with 2.6.31
References: <56acieJJ2fF.A.nEB.Hzl0KB@chimera>	<L6tb-VyKHZK.A.PaB.Ozl0KB@chimera>	<C4F8B19E-F4B4-47F3-AE5B-4581C8E3F3AE@gmail.com>	<87ljjgfcbu.fsf@spindle.srvr.nix>	<alpine.LFD.2.01.0910121703390.3438@localhost.localdomain>	<alpine.LFD.2.01.0910122004200.3438@localhost.localdomain> <20091013113232.384b2432@lxorguk.ukuu.org.uk>
In-Reply-To: <20091013113232.384b2432@lxorguk.ukuu.org.uk>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> The tty_buffer_request_room() is a hint to help better allocation. It's
> also only safe to run from the receiving path of the driver (which
> has always been assumed not to make two parallel calls to the function at
> once.

Yes, the locking only synchronizes between
producer and consumer. It does not coordinate between
multiple producers as it provides a lot of flexibility
(and responsibility) to the producer in how to fill the buffers.

-- 
Paul Fulghum
MicroGate Systems, Ltd.
=Customer Driven, by Design=
(800)444-1982
(512)345-7791 (Direct)
(512)343-9046 (Fax)
Central Time Zone (GMT -5h)
www.microgate.com
