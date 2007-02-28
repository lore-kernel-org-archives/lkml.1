Return-Path: <linux-kernel-owner+w=401wt.eu-S1752182AbXB1NAf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182AbXB1NAf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 08:00:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752184AbXB1NAf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 08:00:35 -0500
Received: from terminus.zytor.com ([192.83.249.54]:56422 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182AbXB1NAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 08:00:34 -0500
Message-ID: <45E57CE5.5010003@zytor.com>
Date: Wed, 28 Feb 2007 05:00:21 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: "Mathiasen, Torben" <Torben.Mathiasen@hp.com>
CC: Timur Tabi <timur@freescale.com>, linux-kernel@vger.kernel.org
Subject: Re: lanana: Add major/minor entries for PPC QE UART devices
References: <45E46976.6060600@freescale.com> <93C4769E3BED6B42B7203BD6F065654C08C5D6E8@dmoexc01.emea.cpqcorp.net>
In-Reply-To: <93C4769E3BED6B42B7203BD6F065654C08C5D6E8@dmoexc01.emea.cpqcorp.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mathiasen, Torben wrote:
> 
> Got around looking at this one. I'm fine with this approach, but the
> CPM5 fix looks wrong. Shouldn't it be:
> 
> 49 = /dev/ttyCPM3		PPC CPM (SCC or SMC) - port 3
> 
> instead?
> 

Well, how many CPM devices can exist?  If there are really 6 ports 
possible, they need minors up to 51.

Also, if QE really is just CPM v3, and they share the same minors, why 
change the name?

	-hpa
