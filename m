Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236Ab0CHSuu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 13:50:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50144 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754470Ab0CHSup (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 13:50:45 -0500
Message-ID: <4B9546E6.6050006@zytor.com>
Date: Mon, 08 Mar 2010 10:50:14 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: "Martin K. Petersen" <martin.petersen@oracle.com>
CC: James Bottomley <James.Bottomley@suse.de>, Tejun Heo <tj@kernel.org>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Daniel Taylor <Daniel.Taylor@wdc.com>, Jeff Garzik <jeff@garzik.org>,
       Mark Lord <kernel@teksavvy.com>, tytso@mit.edu,
       hirofumi@mail.parknet.co.jp, Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, irtiger@gmail.com,
       Matthew Wilcox <matthew@wil.cx>, aschnell@suse.de, knikanth@suse.de,
       jdelvare@suse.de
Subject: Re: ATA 4 KiB sector issues.
References: <4B947393.2050002@kernel.org>	<1268031640.4389.11.camel@mulgrave.site>	<yq1vdd6bzgz.fsf@sermon.lab.mkp.net>	<yq1mxyibz7o.fsf@sermon.lab.mkp.net> <yq1iq96bz22.fsf@sermon.lab.mkp.net>
In-Reply-To: <yq1iq96bz22.fsf@sermon.lab.mkp.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2010 07:41 AM, Martin K. Petersen wrote:
>>>>>> "Martin" == Martin K Petersen <martin.petersen@oracle.com> writes:
> 
>>>>>> "Martin" == Martin K Petersen <martin.petersen@oracle.com> writes:
> Martin> There are 4 KB LBS SSDs out there but in general the industry is
> Martin> sticking to ATA for local boot.
> 
> Martin> Thus implying that ATA doesn't support 4 KB LBS, just that
> Martin> people stick to the tried-and-true 512.
> 
> *sigh* I haven't had my breakfast tea yet...
> 
> What I meant to say was that I know ATA supports 4 KB LBS and that
> nobody appears to care about it.
> 

Well, apparently Western Digital are looking at it for USB drives due to
XP compatibility requirements -- those presumably are ATA internally and
use a USB-ATA bridge.

On the flipside, though, there really is very little net benefit to 4K
as opposed to 512 byte logical sectors: the additional protocol overhead
is relatively minimal, and as long as writes are aligned full blocks,
there shouldn't be any additional overhead on either the OS or the drive
side.  On the plus side, you get full compatibility with the existing
software stack.  The equation really seems rather simple.

	-hpa
