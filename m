Return-Path: <linux-kernel-owner+w=401wt.eu-S1756138AbYIRPoO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138AbYIRPoO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 11:44:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753534AbYIRPn7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 11:43:59 -0400
Received: from orion2.pixelized.ch ([195.190.190.13]:33123 "EHLO
	orion.pixelized.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800AbYIRPn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 11:43:58 -0400
Message-ID: <48D27734.3040600@cateee.net>
Date: Thu, 18 Sep 2008 17:43:48 +0200
From: "Giacomo A. Catenazzi" <cate@cateee.net>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: diet-kconfig: a script to trim unneeded kconfigs
References: <s5hbpyny7bl.wl%tiwai@suse.de> <20080918122541.2c3c7b39@areia.chehab.org>
In-Reply-To: <20080918122541.2c3c7b39@areia.chehab.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mauro Carvalho Chehab wrote:
> Hi Takashi,
> 
> On Wed, 17 Sep 2008 01:55:26 +0200
> Takashi Iwai <tiwai@suse.de> wrote:

>> The script is VERY hackish.  I should have begun with perl or whatever
>> better script language, but I chose bash and co.  So, don't expect
>> much code quality.  I'm no script guy after all :)
> 
> Using just a shellscript and binutils seems to be better than using other
> tools, since it allows the usage on minimal configured systems where the user
> might not have perl or other scripting languages.

But very slow, complex and not enough powerful:
The tools should have extensive knowledge about Kconfig,
and the CONFIG_ dependencies; it should handle a lot of
structures (text/binary; line/record oriented; etc.), which
it is not easy in shell (awk, od, sed with extended regexp are
not core utilities).

So my suggestion is: do it in a high level language, to find and
stabilize the design, and then integrate it in kconfig later (using
C).

ciao
	cate

