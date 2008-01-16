Return-Path: <linux-kernel-owner+w=401wt.eu-S1757391AbYAPIEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757391AbYAPIEk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 03:04:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752742AbYAPIEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 03:04:33 -0500
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:60825 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199AbYAPIEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 03:04:32 -0500
Message-ID: <478DB9B4.1030107@keyaccess.nl>
Date: Wed, 16 Jan 2008 09:00:52 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Dave Young <hidave.darkstar@gmail.com>
CC: Frans Pop <elendil@planet.nl>, bjorn.helgaas@hp.com,
       Len Brown <lenb@kernel.org>, akpm@osdl.org, cholvenstot@comcast.net,
       linux-kernel@vger.kernel.org, shaohua.li@intel.com, trenn@suse.de,
       yakui.zhao@intel.com
Subject: Re: pnpacpi : exceeded the max number of IO resources
References: <1196428488.7066.6.camel@localhost> <47508D3C.9050507@keyaccess.nl>	 <475436A3.90906@keyaccess.nl> <200801082250.51026.lenb@kernel.org>	 <E1JCXK5-0002GH-0x@faramir.fjphome.nl> <4784DE94.8020508@keyaccess.nl> <a8e1da0801152155x18cfd0dcvfe638323275e539d@mail.gmail.com>
In-Reply-To: <a8e1da0801152155x18cfd0dcvfe638323275e539d@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16-01-08 06:55, Dave Young wrote:

> I noticed the port number changed to 40 in 2.6.24-rc8, but it's not
> enough for me still.

Yes, that's known. In .23 even more were (silently) ignored though. Since 
.24-rc8 you should at least get just 1 warning (per resource type) and if 
all's well .25 should kill the static limit completely.

Rene.
