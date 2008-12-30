Return-Path: <linux-kernel-owner+w=401wt.eu-S1753221AbYL3HJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221AbYL3HJT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 02:09:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751585AbYL3HJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 02:09:04 -0500
Received: from gmp-eb-inf-1.sun.com ([192.18.6.21]:48822 "EHLO
	gmp-eb-inf-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbYL3HJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 02:09:02 -0500
X-Greylist: delayed 764 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Dec 2008 02:09:01 EST
Date: Tue, 30 Dec 2008 09:55:57 +0300
From: Alex Tomas <bzzz@Sun.COM>
Subject: Re: [dm-devel] Re: jbd2 inside a device mapper module
In-reply-to: <20081229210537.GN4127@blitiri.com.ar>
To: Alberto Bertogli <albertito@blitiri.com.ar>
Cc: Shyam_Iyer@Dell.com, dm-devel@redhat.com, linux-ext4@vger.kernel.org,
       tytso@MIT.EDU, linux-kernel@vger.kernel.org
Message-id: <4959C5FD.3050305@sun.com>
MIME-version: 1.0
Content-type: text/plain; format=flowed; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
References: <20081225143535.GA4127@blitiri.com.ar>
 <20081227200127.GX5000@webber.adilger.int>
 <46A00B48CC54E4468EF6911F877AC4CA01DDBB66@blrx3m10.blr.amer.dell.com>
 <20081229210537.GN4127@blitiri.com.ar>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.10) Gecko/20070302
 Fedora/1.5.0.10-1.fc6 pango-text Thunderbird/1.5.0.10 Mnenhy/0.7.5.666
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

one good thing about JBD is that you can't update target block and csum
atomically. so, either you use some form of COW or you use journalling.
given we already have JBD it'd make sense to use it?

thanks, Alex

Alberto Bertogli wrote:
> I think I'll go with the "two metadatas" approach and see how it goes.
> Worst case scenario is that I have to drop that code, which means to be
> back where I am now, only with one less option.
> 
> Thanks,
> 		Alberto
> 

