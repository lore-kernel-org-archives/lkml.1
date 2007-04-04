Return-Path: <linux-kernel-owner+w=401wt.eu-S934049AbXDDAnN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934049AbXDDAnN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 20:43:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966213AbXDDAnN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 20:43:13 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:45184 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934052AbXDDAnM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 20:43:12 -0400
Date: Wed, 4 Apr 2007 02:42:08 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Pavel Machek <pavel@ucw.cz>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 10/16] show-partitions-on-mount-error.diff
In-Reply-To: <20070402185958.GB4628@ucw.cz>
Message-ID: <Pine.LNX.4.61.0704040240440.10155@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704011900470.8018@yvahk01.tjqt.qr>
 <Pine.LNX.4.61.0704012008590.12316@yvahk01.tjqt.qr> <20070402185958.GB4628@ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 2 2007 18:59, Pavel Machek wrote in http://lkml.org/lkml/2007/4/3/85:
>
>> + * to give the victim some idea of what went wrong
>> + */
>> +void printk_all_partitions(void)
>> +{
>> +	int n;
>> +        struct gendisk* sgp;
>> +	mutex_lock(&block_subsys_lock);
>
>tabs-vs-spaces problem.

Already fixed and sent out in http://lkml.org/lkml/2007/4/2/75


Jan
-- 
