Return-Path: <linux-kernel-owner+w=401wt.eu-S932200AbZKBS3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932200AbZKBS3k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 13:29:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932155AbZKBS3j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 13:29:39 -0500
Received: from mail.perches.com ([173.55.12.10]:1177 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932152AbZKBS3j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 13:29:39 -0500
Subject: Re: [PATCH v2 5/7] vsprintf: reduce code size by avoiding extra
 check
From: Joe Perches <joe@perches.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: =?ISO-8859-1?Q?Andr=E9?= Goddard Rosa <andre.goddard@gmail.com>,
       laijs@cn.fujitsu.com, mingo@elte.hu, davem@davemloft.net,
       akpm@linux-foundation.org, harvey.harrison@gmail.com,
       linux list <linux-kernel@vger.kernel.org>
In-Reply-To: <20091102181944.GA4880@nowhere>
References: <b8bf37780911020926rd5e40b1h957c803f7bb21196@mail.gmail.com>
	 <20091102181944.GA4880@nowhere>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 02 Nov 2009 10:29:43 -0800
Message-ID: <1257186583.28925.47.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-02 at 19:19 +0100, Frederic Weisbecker wrote:
> On Mon, Nov 02, 2009 at 03:26:36PM -0200, André Goddard Rosa wrote:
> > Subject: [PATCH v2 5/7] vsprintf: reduce code size by avoiding extra check
> >    text    data     bss     dec     hex filename
> >   15735       0       8   15743    3d7f lib/vsprintf.o-before
> >   15719       0       8   15727    3d6f lib/vsprintf.o-minus-double-check
> Please add a changelog in your patches, I mean something that
> explain your practical change.

Read the subject and try not to go overboard.
I think the changelog André provided is perfect.


