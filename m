Return-Path: <linux-kernel-owner+w=401wt.eu-S1752463AbXCULms@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463AbXCULms (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 07:42:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752475AbXCULms
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 07:42:48 -0400
Received: from smtp.nokia.com ([131.228.20.170]:54934 "EHLO
	mgw-ext11.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463AbXCULms convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 07:42:48 -0400
Subject: Re: [PATCH 00/22 take 3] UBI: Unsorted Block Images
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: tglx@linutronix.de
Cc: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>,
       Matt Mackall <mpm@selenic.com>, Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <1174476334.10840.49.camel@localhost.localdomain>
References: <20070318162720.GI10459@waste.org>
	 <1174236579.17249.6.camel@sauron> <20070318191812.GM4892@waste.org>
	 <20070318203149.GC29295@crusty.rchland.ibm.com>
	 <20070319170838.GP4892@waste.org>
	 <1174328188.30079.46.camel@zod.rchland.ibm.com>
	 <20070319195442.GT4892@waste.org>
	 <1174338329.13341.633.camel@localhost.localdomain>
	 <20070319223205.GZ4892@waste.org>
	 <1174351366.13341.739.camel@localhost.localdomain>
	 <20070321110528.GC3785@lazybastard.org>
	 <1174476334.10840.49.camel@localhost.localdomain>
Content-Type: text/plain; charset=utf-8
Date: Wed, 21 Mar 2007 13:36:58 +0200
Message-Id: <1174477018.17249.197.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 21 Mar 2007 11:37:13.0008 (UTC) FILETIME=[44BCB300:01C76BAD]
X-eXpurgate-Category: 1/0
X-eXpurgate-ID: 149371::070321133720-57F51BB0-3D3B2212/0-0/0-1
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-03-21 at 12:25 +0100, Thomas Gleixner wrote:
> Last time I talked to you about that, you said it would be possible and
> fixable. We talked about several mechanisms, which would allow a
> filesystem or other users to hint such things to UBI.
> 
> Even if the LogFS wear levelling is so superior, it CAN'T do across
> device wear levelling.

Exactly. Although it is true that it cannot be _as good_ as FS, one can
optimize this by means of asking FS beforehand and make it quite OK. And
eraseblock movement is not so frequent event - we do it only once the
erase counter difference is more then 4Ki (although it is tunable).

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

