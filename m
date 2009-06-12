Return-Path: <linux-kernel-owner+w=401wt.eu-S1755989AbZFLRF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989AbZFLRF3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 13:05:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751779AbZFLREy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 13:04:54 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:65417 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100AbZFLREx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 13:04:53 -0400
Date: Fri, 12 Jun 2009 10:03:59 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: Nico Schottelius <nico-linuxsetlocalversion@schottelius.org>
cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] scripts/setlocalversion on readonly source
In-Reply-To: <20090612075952.GA22436@ikn.schottelius.org>
Message-ID: <alpine.DEB.2.01.0906120959050.6439@bogon>
References: <20090611153332.d168e58e.akpm@linux-foundation.org> <20090612043922.GA13001@uranus.ravnborg.org> <alpine.DEB.2.01.0906091323520.6439@bogon> <20090612075952.GA22436@ikn.schottelius.org>
User-Agent: Alpine 2.01 (DEB 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX18j50Jhyc0jwTC55ytsl6xCL/booWH2HkqimEy
 8hhZzJ0DqDZ5d5Ux52wDng0erhZHphZ/7E89p/4I7bQb74wngh
 KQ1JFG9qbGmZY58JnnR9Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Jun 2009, Nico Schottelius wrote:
> changing stuff (mtime here) where it is not necessary is maybe not
> the best thing todo. I suggest instead checking for a writable directory
> (which is what you want todo anyway):
> 
> [ -w . ] && git update-index --refresh --unmerged > /dev/null

Even better, thanks!

Christian.
-- 
BOFH excuse #187:

Reformatting Page. Wait...
