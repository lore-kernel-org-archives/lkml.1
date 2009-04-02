Return-Path: <linux-kernel-owner+w=401wt.eu-S1765260AbZDBTU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765260AbZDBTU2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 15:20:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754002AbZDBTUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 15:20:11 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:55384 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753940AbZDBTUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 15:20:09 -0400
Message-ID: <49D50F37.7070201@freescale.com>
Date: Thu, 02 Apr 2009 14:17:11 -0500
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: avorontsov@ru.mvista.com
CC: Timur Tabi <timur@freescale.com>, linuxppc-dev@ozlabs.org,
       Marcel Ziswiler <marcel@ziswiler.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] QE USB Host Integration for MPC832x
References: <1238622396-9768-1-git-send-email-marcel@ziswiler.com>	<20090402183357.GA29050@oksana.dev.rtsoft.ru>	<20090402183631.GA6699@oksana.dev.rtsoft.ru>	<49D5071D.50001@freescale.com> <20090402191159.GA14626@oksana.dev.rtsoft.ru>
In-Reply-To: <20090402191159.GA14626@oksana.dev.rtsoft.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anton Vorontsov wrote:
> On Thu, Apr 02, 2009 at 01:42:37PM -0500, Timur Tabi wrote:
>> Anton Vorontsov wrote:
>>
>>> Oh, I was wrong. fsl_qe_udc driver uses mpc8360 compatible for
>>> matching, so you can't remove it. :-/
>> Ugh, that's a bug in the driver then.
> 
> Yes, but that depends on what chip was the first one? MPC8323 or
> MPC8360?

Actually, it depends on which one we picked in the devtree binding 
(assuming they're compatible both ways), which appears to be mpc8323.

-Scott
