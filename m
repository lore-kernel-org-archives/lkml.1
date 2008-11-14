Return-Path: <linux-kernel-owner+w=401wt.eu-S1755152AbYKNVI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755152AbYKNVI6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 16:08:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751259AbYKNVIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 16:08:50 -0500
Received: from yx-out-2324.google.com ([74.125.44.29]:29075 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbYKNVIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 16:08:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=oY7ZCRhzjChKn/cNqovy2CQ74/FhbS4YmcoT36/VABQCAluPcdajYBLbcbeWAdq0+S
         QY8PHt1/6+WdiJbcqsAzrnebseQzuKmUWDH0MVmnRX0VpdH7uQZ7+U11+Tjy2hoRwNmB
         iZrI+opGq2R4VUjB9fqkJ89/Xk70FlTfijnGs=
Subject: Re: [v4l-dvb-maintainer] [PATCH] dvb: usb vendor_ids/product_ids
 are __le16
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andy Walls <awalls@radix.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
       v4l-maintainer <v4l-dvb-maintainer@linuxtv.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
In-Reply-To: <1226696157.3312.92.camel@palomino.walls.org>
References: <1226686796.5483.33.camel@brick> <491DCBDD.4000703@linuxtv.org>
	 <1226689669.5483.36.camel@brick>
	 <37219a840811141115g539ef85fo81136ebd479f016f@mail.gmail.com>
	 <1226690438.5483.39.camel@brick>
	 <412bdbff0811141125x34de747dm85b47f61b604219a@mail.gmail.com>
	 <1226691865.5483.47.camel@brick>
	 <1226696157.3312.92.camel@palomino.walls.org>
Content-Type: text/plain
Date: Fri, 14 Nov 2008 13:08:45 -0800
Message-Id: <1226696926.5483.48.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-11-14 at 15:55 -0500, Andy Walls wrote:
> On Fri, 2008-11-14 at 11:44 -0800, Harvey Harrison wrote:
> 
> > But I'd suggest
> > that if you want to improve the maintainability of this code that someone
> > in v4l-land start running sparse regularly 
> 
> For those who don't get the daily 'bot mail on the v4l-dvb-maintainer
> list, Hans Verkuil's v4l-dvb build 'bot runs sparse builds daily for all
> of v4l-dvb land:
> 
> http://linuxtv.org/pipermail/v4l-dvb-maintainer/2008-November/008595.html
> 
> Although developers won't see waring/error outputs from those runs until
> after their changes are merged in the main v4l-dvb repo.
> 
> The latest kernel this automatic sparse build compiles is currently
> 2.26.28-rc4.  I've used it to monitor the cx18 driver for sparse build
> errors so I could address them - it's quite convenient.
> 

Does Hans' build turn on __CHECK_ENDIAN__? That would help as well.

Harvey

