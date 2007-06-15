Return-Path: <linux-kernel-owner+w=401wt.eu-S1752623AbXFOIwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623AbXFOIwX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 04:52:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752180AbXFOIvz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 04:51:55 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:17385 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbXFOIvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 04:51:54 -0400
Date: Fri, 15 Jun 2007 10:51:53 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Joe Perches <joe@perches.com>
cc: holzheu@linux.vnet.ibm.com, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, randy.dunlap@oracle.com, akpm@osdl.org,
       mtk-manpages@gmx.net, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com
Subject: Re: [RFC/PATCH] Documentation of kernel messages
In-Reply-To: <1181761496.6020.158.camel@localhost>
Message-ID: <Pine.LNX.4.64.0706151051050.32724@fbirervta.pbzchgretzou.qr>
References: <1181747217.29512.9.camel@localhost.localdomain> 
 <20070613175147.GB14355@suse.de>  <1181758680.26375.25.camel@localhost.localdomain>
 <1181761496.6020.158.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 13 2007 12:04, Joe Perches wrote:
>On Wed, 2007-06-13 at 20:18 +0200, holzheu wrote:
>> But they unfortunately do not solve our problem. We need an identifier
>> for a documented message in order to find the right description for a
>> message.
>
>I believe it better to simply add __FILE__ & __LINE__ to the

Erk, no. That bloats the kernel to the max. Especially since kernel
files are compiled with a rather longish path.



	Jan
-- 
