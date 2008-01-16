Return-Path: <linux-kernel-owner+w=401wt.eu-S1758188AbYAPCoE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758188AbYAPCoE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 21:44:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753397AbYAPCnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 21:43:53 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47455 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023AbYAPCnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 21:43:52 -0500
Date: Wed, 16 Jan 2008 11:43:08 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC][PATCH 3/5] add /dev/mem_notify device
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Marcelo Tosatti <marcelo@kvack.org>,
       Daniel Spang <daniel.spang@gmail.com>, Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20080115134209.7b3c2f7e@lxorguk.ukuu.org.uk>
References: <20080115202711.11A6.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080115134209.7b3c2f7e@lxorguk.ukuu.org.uk>
Message-Id: <20080116114121.11B7.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan

> > > It also appears there is no way to wait for memory shortages (processes
> > > that can free memory easily) only for memory to start appearing.
> > 
> > poll() with never timeout don't fill your requirement?
> > to be honest, maybe I don't understand your afraid yet. sorry.
> 
> My misunderstanding. There is in fact no way to wait for memory to become
> available. The poll() method you provide works nicely waiting for
> shortages and responding to them by freeing memory.
> 
> It would be interesting to add FASYNC support to this. Some users have
> asked for a signal when memory shortage occurs (as IBM AIX provides
> this). FASYNC support would allow a SIGIO to be delivered from this
> device when memory shortages occurred. Poll as you have implemented is of
> course the easier way for a program to monitor memory and a better
> interface.

OK.
I will challenge implement at mem_notify v5.


- kosaki


