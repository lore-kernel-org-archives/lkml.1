Return-Path: <linux-kernel-owner+w=401wt.eu-S1751868AbZGOD2J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751868AbZGOD2J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 23:28:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751142AbZGOD2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 23:28:08 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:41214 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbZGOD2H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 23:28:07 -0400
From: "Zhang, Sonic" <Sonic.Zhang@analog.com>
X-IronPort-AV: E=Sophos;i="4.42,401,1243828800"; 
   d="scan'208";a="3852469"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH/RFC] NOMMU: drop page cache whenever any alloc fails due to low memory
Date: Wed, 15 Jul 2009 11:29:10 +0800
Message-ID: <0F1B54C89D5F954D8535DB252AF412FA045E8C0F@chinexm1.ad.analog.com>
In-Reply-To: <1247581838.7500.98.camel@twins>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH/RFC] NOMMU: drop page cache whenever any alloc fails due to low memory
Thread-Index: AcoEj+QLq0oYQysPR+uWOo5sr4T/tAAbEIcA
References: <1247581357-20068-1-git-send-email-vapier@gentoo.org> <1247581838.7500.98.camel@twins>
To: "Peter Zijlstra" <peterz@infradead.org>,
       "Mike Frysinger" <vapier@gentoo.org>
CC: <linux-kernel@vger.kernel.org>, <uclinux-dist-devel@blackfin.uclinux.org>,
       "David Howells" <dhowells@redhat.com>
X-OriginalArrivalTime: 15 Jul 2009 03:27:35.0310 (UTC) FILETIME=[3225FAE0:01CA04FC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The reclaim is not that aggressive.

Sonic 

-----Original Message-----
From: Peter Zijlstra [mailto:peterz@infradead.org] 
Sent: Tuesday, July 14, 2009 10:31 PM
To: Mike Frysinger
Cc: linux-kernel@vger.kernel.org;
uclinux-dist-devel@blackfin.uclinux.org; Zhang, Sonic; David Howells
Subject: Re: [PATCH/RFC] NOMMU: drop page cache whenever any alloc fails
due to low memory

On Tue, 2009-07-14 at 10:22 -0400, Mike Frysinger wrote:
> From: Sonic Zhang <sonic.zhang@analog.com>
> 
> Since no-mmu systems tend to be memory constrained, we want to drop 
> all of the page cache whenever memory gets low.  The only other option

> is to invoke the oom killer, and clearly that's not ideal.

Uhm,.. normally reclaim will already try to drop pagecache.
