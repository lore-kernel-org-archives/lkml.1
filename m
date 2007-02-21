Return-Path: <linux-kernel-owner+w=401wt.eu-S1423227AbXBUWsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423227AbXBUWsQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 17:48:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423233AbXBUWsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 17:48:15 -0500
Received: from smtp.osdl.org ([65.172.181.24]:53701 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423227AbXBUWsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 17:48:10 -0500
Date: Wed, 21 Feb 2007 14:48:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 006 of 6] md: Add support for reshape of a raid6
Message-Id: <20070221144806.e6eed85c.akpm@linux-foundation.org>
In-Reply-To: <1070220063516.16208@suse.de>
References: <20070220172544.15678.patches@notabene>
	<1070220063516.16208@suse.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Feb 2007 17:35:16 +1100
NeilBrown <neilb@suse.de> wrote:

> +		for (i = conf->raid_disks ; i-- ;  ) {

That statement should be dragged out, shot, stomped on then ceremonially
incinerated.

What's wrong with doing

	for (i = 0; i < conf->raid_disks; i++) {

in a manner which can be understood without alcoholic fortification?

ho hum.
