Return-Path: <linux-kernel-owner+w=401wt.eu-S1751957AbXBBLHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957AbXBBLHh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 06:07:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751956AbXBBLHh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 06:07:37 -0500
Received: from sardaukar.technologeek.org ([213.41.134.240]:55145 "EHLO
	sonic.technologeek.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751952AbXBBLHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 06:07:36 -0500
X-Greylist: delayed 1357 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Feb 2007 06:07:36 EST
From: Julien BLACHE <jb@jblache.org>
To: Thomas Glanzmann <thomas@glanzmann.de>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       Fagyal Csongor <concept@conceptonline.hu>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: sky2 hangs
References: <20070201185532.GL13130@cip.informatik.uni-erlangen.de>
	<42007.80.98.159.250.1170369983.squirrel@www.hunhost.com>
	<20070201145815.199bfe1a@freekitty>
	<20070202063104.GA13130@cip.informatik.uni-erlangen.de>
Date: Fri, 02 Feb 2007 11:44:55 +0100
In-Reply-To: <20070202063104.GA13130@cip.informatik.uni-erlangen.de> (Thomas
	Glanzmann's message of "Fri, 2 Feb 2007 07:31:04 +0100")
Message-ID: <873b5o25zs.fsf@sonic.technologeek.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Glanzmann <thomas@glanzmann.de> wrote:

Hi,

>> I can reproduce the problem now (on mac mini). Interestingly it seems
>> to whack the whole ethernet switch when it happens.

I've observed that too, on a cheap DLink switch.

Next time sky2 hangs on me I'll try to reset the PHY and see if that
helps. I can usually trigger the hang by doing a couple of ifconfig
up/down on the interface, though I'm not getting any error message
from the driver when that happens.

JB.

-- 
Julien BLACHE                                   <http://www.jblache.org> 
<jb@jblache.org>                                  GPG KeyID 0xF5D65169
