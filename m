Return-Path: <linux-kernel-owner+w=401wt.eu-S1757386AbXEINOP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757386AbXEINOP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 09:14:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756047AbXEINN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 09:13:58 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:48352 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753639AbXEINN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 09:13:57 -0400
Date: Wed, 9 May 2007 15:06:10 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
cc: Thomas Gleixner <tglx@linutronix.de>,
       =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>,
       Andrew Morton <akpm@osdl.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       David Chinner <dgc@sgi.com>
Subject: Re: [PATCH 1/2] LogFS proper
In-Reply-To: <20070508161703.GA18035@2ka.mipt.ru>
Message-ID: <Pine.LNX.4.61.0705091506000.32349@yvahk01.tjqt.qr>
References: <20070507215913.GA15054@lazybastard.org> <20070507220036.GB15054@lazybastard.org>
 <1178608950.3042.273.camel@localhost.localdomain>
 <Pine.LNX.4.61.0705081439270.17280@yvahk01.tjqt.qr>
 <1178639681.3042.334.camel@localhost.localdomain> <20070508161703.GA18035@2ka.mipt.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 8 2007 20:17, Evgeniy Polyakov wrote:
>> > >> +static int __logfs_readdir(struct file *file, void *buf, filldir_t filldir)
>> > >> +{
>> > >> +		err = read_dir(dir, &dd, pos);
>> > >> +		if (err == -EOF)
>> > >> +			break;
>> > >
>> > >	-EOF results in a return code 0 ?
>> > 
>> > Results in a return code -256.
>> 
>> Really ? It breaks out of the loop and returns 0 !

See, it's so confusing!


Jan
-- 
