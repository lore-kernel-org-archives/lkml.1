Return-Path: <linux-kernel-owner+w=401wt.eu-S1754560AbZKQQo7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560AbZKQQo7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 11:44:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751770AbZKQQo6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 11:44:58 -0500
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:24705 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbZKQQo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 11:44:58 -0500
Subject: Re: [RFC] Block IO Controller V2 - some results
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com
In-Reply-To: <4e5e476b0911170817s39286103g3796f25cba9f623c@mail.gmail.com>
References: <1258404660.3533.150.camel@cail>
	 <20091116221827.GL13235@redhat.com> <1258461527.2862.2.camel@cail>
	 <20091117141411.GA22462@redhat.com>
	 <4e5e476b0911170817s39286103g3796f25cba9f623c@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 Nov 2009 11:45:00 -0500
Message-ID: <1258476300.6084.104.camel@cail>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-17 at 17:17 +0100, Corrado Zoccolo wrote:
> Hi Vivek,
> the performance drop reported by Alan was my main concern about your
> approach. Probably you should mention/document somewhere that when the
> number of groups is too large, there is large decrease in random read
> performance.
> 
> However, we can check few things:
> * is this kernel built with HZ < 1000? The smallest idle CFQ will do
> is given by 2/HZ, so running with a small HZ will increase the impact
> of idling.

FYI:

CONFIG_NO_HZ=y
CONFIG_HZ_1000=y
CONFIG_HZ=1000



