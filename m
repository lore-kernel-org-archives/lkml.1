Return-Path: <linux-kernel-owner+w=401wt.eu-S1755343AbYAPNIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343AbYAPNIA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 08:08:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752966AbYAPNHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 08:07:52 -0500
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:41928 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924AbYAPNHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 08:07:51 -0500
Message-ID: <478E00D2.50908@keyaccess.nl>
Date: Wed, 16 Jan 2008 14:04:18 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Dave Young <hidave.darkstar@gmail.com>, Frans Pop <elendil@planet.nl>,
       bjorn.helgaas@hp.com, Len Brown <lenb@kernel.org>, akpm@osdl.org,
       cholvenstot@comcast.net, linux-kernel@vger.kernel.org,
       shaohua.li@intel.com, trenn@suse.de, yakui.zhao@intel.com
Subject: Re: pnpacpi : exceeded the max number of IO resources
References: <1196428488.7066.6.camel@localhost> <47508D3C.9050507@keyaccess.nl>	 <475436A3.90906@keyaccess.nl> <200801082250.51026.lenb@kernel.org>	 <E1JCXK5-0002GH-0x@faramir.fjphome.nl> <4784DE94.8020508@keyaccess.nl> <a8e1da0801152155x18cfd0dcvfe638323275e539d@mail.gmail.com> <478DB9B4.1030107@keyaccess.nl>
In-Reply-To: <478DB9B4.1030107@keyaccess.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16-01-08 09:00, Rene Herman wrote:

> On 16-01-08 06:55, Dave Young wrote:
> 
>> I noticed the port number changed to 40 in 2.6.24-rc8, but it's not
>> enough for me still.
> 
> Yes, that's known. In .23 even more were (silently) ignored though. 
> Since .24-rc8 you should at least get just 1 warning (per resource type)

Assuming, that is, that Linus would've applied Len's trivial fix here:

http://lkml.org/lkml/2008/1/14/251

> and if all's well .25 should kill the static limit completely.

Rene.

