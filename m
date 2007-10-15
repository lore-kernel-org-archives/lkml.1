Return-Path: <linux-kernel-owner+w=401wt.eu-S1754564AbXJOJGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564AbXJOJGj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 05:06:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757899AbXJOJGY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 05:06:24 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:23885 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757885AbXJOJGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 05:06:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=S95/+WJxTpVMU4KZsnYvK8yWq73cdezYaB9lK/F28P/ZNDdcqcu3iMZ2R0KAO8FO+Krcrf51At6dcK1DsnqlWUaiHK0drp09JF7OeWN87FRYDf+751nl+dAuZgdK3k6m68litV517iOyehaGmCH/FLOf47Ai8s6tOmg2ACcgHeg=
Message-ID: <646765f40710150206j75af4c4dwac4f4565451b64b1@mail.gmail.com>
Date: Mon, 15 Oct 2007 19:06:20 +1000
From: "Julian Calaby" <julian.calaby@gmail.com>
To: "Rob Landley" <rob@landley.net>
Subject: Re: What still uses the block layer?
Cc: "Theodore Tso" <tytso@mit.edu>,
       "James Bottomley" <James.Bottomley@steeleye.com>,
       "Matthew Wilcox" <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, "Jens Axboe" <axboe@suse.de>,
       "Suparna Bhattacharya" <suparna@in.ibm.com>,
       "Nick Piggin" <piggin@cyberone.com.au>
In-Reply-To: <200710150304.00901.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200710112011.22000.rob@landley.net>
	 <200710141845.44750.rob@landley.net> <20071015014503.GF9715@thunk.org>
	 <200710150304.00901.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/07, Rob Landley <rob@landley.net> wrote:
> I note that the eth0 and eth1 names are dynamically assigned on a first come
> first serve basis (like scsi).  This never causes me a problem because the
> driver loading order is constant, and once you figure out that eth0 is
> gigabit and eth1 is the 80211g it _stays_ that way across reboots, reliably.
> Yeah, it's a heuristic.  Hands up everybody relying on such a heuristic in
> the real world.

Umm, not quite, from my experiences with pre-production wireless
drivers, (another story, another time) fancy stuff is being done in
udev to make sure that your gigabit card is always assigned to eth0.

-- 

Julian Calaby

Email: julian.calaby@gmail.com
