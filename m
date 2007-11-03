Return-Path: <linux-kernel-owner+w=401wt.eu-S1760236AbXKCUH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760236AbXKCUH7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 16:07:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755565AbXKCUHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 16:07:50 -0400
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:53353
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755141AbXKCUHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 16:07:48 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: RFC: Reproducible oops with lockdep on count_matching_names()
Date: Sat, 3 Nov 2007 21:06:54 +0100
User-Agent: KMail/1.9.6
Cc: "Peter Zijlstra" <peterz@infradead.org>,
       "Michael Wu" <flamingice@sourmilk.net>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       "John W. Linville" <linville@tuxdriver.com>,
       "Ingo Molnar" <mingo@redhat.com>,
       "Johannes Berg" <johannes@sipsolutions.net>,
       linux-kernel@vger.kernel.org, "Michael Chan" <mchan@broadcom.com>,
       netdev@vger.kernel.org
References: <20071101191716.GA3201@pogo> <1194001120.27652.353.camel@twins> <43e72e890711031258g4ccd9cd0hc4520e9473f6ce49@mail.gmail.com>
In-Reply-To: <43e72e890711031258g4ccd9cd0hc4520e9473f6ce49@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711032106.56569.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 03 November 2007 20:58:09 Luis R. Rodriguez wrote:
> I was using SLAB and ran into other strange oops, as the one below,
> but after switching to SLUB, after Michael Buesch's suggestion that
> one went away... The lockdep segfault is still present, however.

Who is responsible for slab btw?
I mean, someone should be interested in getting this bug fixed. :)
When using slab I see random corruptions. I think related to rmmod, but
I'm not sure. I don't see this with slub.

-- 
Greetings Michael.
