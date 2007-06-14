Return-Path: <linux-kernel-owner+w=401wt.eu-S1754109AbXFNRUh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109AbXFNRUh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 13:20:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750909AbXFNRUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 13:20:30 -0400
Received: from bipbip.grupopie.com ([195.23.16.24]:58187 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751111AbXFNRUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 13:20:30 -0400
Message-ID: <467178D3.6010204@grupopie.com>
Date: Thu, 14 Jun 2007 18:20:19 +0100
From: Paulo Marques <pmarques@grupopie.com>
Organization: Grupo PIE
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Al Viro <viro@ftp.linux.org.uk>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Bernd Paysan <bernd.paysan@gmx.de>, Krzysztof Halasa <khc@pm.waw.pl>,
       linux-kernel@vger.kernel.org
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <466A3EC6.6030706@netone.net.tr> <200706141023.21624.bernd.paysan@gmx.de> <20070614153935.GO21478@ftp.linux.org.uk> <200706141832.58526.bernd.paysan@gmx.de> <20070614164124.GP21478@ftp.linux.org.uk> <d120d5000706141001o2d00f20cqb4133bf7b9ba11ab@mail.gmail.com> <20070614170902.GQ21478@ftp.linux.org.uk>
In-Reply-To: <20070614170902.GQ21478@ftp.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> On Thu, Jun 14, 2007 at 01:01:20PM -0400, Dmitry Torokhov wrote:
>>> Multiple authors == need permission from each author with enough
>>> contributions to that file to make the contributions in question
>>> copyrightable.
>>>
>>> And in my case (and case of gregkh, and...) that would be considerably
>>> more than a couple of files.  Really.
>> I would expect that if you contribute to a file that explicitely says
>> "GPL v2 or later" and you do not change that wording then you agree
>> GPL v2 or later for that particular contribution. So for example
>> drivers/net/plip.c could be changed to GPL v3 even though you
>> contributed to it.
> 
> After you exclude such cases it's still more than a couple of files...

FWIW,

$ find -name "*.c" | xargs grep "any later version" | wc -l
3138
$ find -name "*.c" | wc -l
9482

Watching the output of the first grep without "wc -l" shows that, 
although it is not 100% accurate, it is still ok just to get a rough 
estimate.

So yes, ~6300 files are definitely more than a couple ;)

-- 
Paulo Marques - www.grupopie.com

"God is love. Love is blind. Ray Charles is blind. Ray Charles is God."
