Return-Path: <linux-kernel-owner+w=401wt.eu-S1760541AbXKQPxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760541AbXKQPxv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 10:53:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753346AbXKQPxn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 10:53:43 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:27900 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178AbXKQPxm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 10:53:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=ik7fu/9q0lCRGbr4MT2YY0x+vy0fFvPDbH0VMN56NuqiTUAq1blcQaMze3bRDm3ITf3D5yE4/5ZCbms8cQIDbT9qYzqGQaEQT6w1iZNhVh6QO2b7BeT+zFv8A+9cIxxd6pR6kw8qObjWmn/IsCyndDI8zTFOe2OW3bA2e7M/aow=
Date: Sat, 17 Nov 2007 16:53:25 +0100
From: Diego Calleja <diegocg@gmail.com>
To: Martin Olsson <mnemo@minimum.se>
Cc: Peter Zijlstra <peterz@infradead.org>, Dane Mutters <dmutters@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: Is it possible to give the user the option to cancel forkbombs?
Message-Id: <20071117165325.3e5f571a.diegocg@gmail.com>
In-Reply-To: <473F281B.60408@minimum.se>
References: <473E815F.30900@minimum.se>
	<20071116213137.6efe3f9e@the-village.bc.nu>
	<473E9290.3040006@minimum.se>
	<1195281942.15929.5.camel@Orchestrator>
	<1195285481.3059.12.camel@twins>
	<473F281B.60408@minimum.se>
X-Mailer: Sylpheed 2.4.5 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

El Sat, 17 Nov 2007 09:42:51 -0800, Martin Olsson <mnemo@minimum.se> escribió:

> I don't think that setting a max process count by default is a 
> good/viable solution. 


I don't see why...OS X had a default limit of 100 processes per uid (increased
to 266 in 10.5) and "it works" (many people notices it, but it's not surprising
since the limit is too restrictive).

If you don't have limits, you can't avoid starvation easily. From my experience,
since I use CFS, fork/compile bombs (forgetting to put a number after make -j...)
are very sluggish mainly because the whole graphic subsystem is paged out.
