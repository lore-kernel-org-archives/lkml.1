Return-Path: <linux-kernel-owner+w=401wt.eu-S1757001AbXFSLGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757001AbXFSLGV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 07:06:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752754AbXFSLGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 07:06:13 -0400
Received: from smtp.nokia.com ([131.228.20.171]:37495 "EHLO
	mgw-ext12.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752949AbXFSLGM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 07:06:12 -0400
Subject: Re: [PATCH/RFC] oops and panic message logging to MTD
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Richard Purdie <rpurdie@openedhand.com>
Cc: linux-mtd <linux-mtd@lists.infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1182250350.5760.42.camel@localhost.localdomain>
References: <1182184301.6074.62.camel@localhost.localdomain>
	 <1182239749.4403.48.camel@sauron>
	 <1182247254.5760.17.camel@localhost.localdomain>
	 <1182248962.4403.60.camel@sauron>
	 <1182250350.5760.42.camel@localhost.localdomain>
Content-Type: text/plain; charset=utf-8
Date: Tue, 19 Jun 2007 14:05:44 +0300
Message-Id: <1182251144.4403.63.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 19 Jun 2007 11:05:45.0057 (UTC) FILETIME=[C89BBD10:01C7B261]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-06-19 at 11:52 +0100, Richard Purdie wrote:
> >  Error
> > code means that something very bad and sever is going on and you have to
> > just refuse working with this device.
> 
> In this case, it will just move on to the next EB. There is code to
> handle no available EBs at which point it will refuse to work with the
> device.

My point is that instead of moving you should return error. You cannot
keep working with this device just because something really bad
happened, you do not know what, and you cannot react accordingly because
you do not know how.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

