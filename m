Return-Path: <linux-kernel-owner+w=401wt.eu-S1751807AbYDEFDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751807AbYDEFDS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2008 01:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751345AbYDEFDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Apr 2008 01:03:07 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:59819 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766AbYDEFDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2008 01:03:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=keb1CbXl9eFzJ/f+HYBs9LML28IhJXjYadvaix0x3HQHACmxkcYwqTo4PHoOBqVmuDxVHXJgA4yD8u9pYCS5uMzYbID7oRVEQTx6RFzIDCZIA/wtoubufJyV+z/Yq2JaiRdio/1TQDuT6nU7VUslu5XVuDCkvCQ6ThckT77KFN8=
Message-ID: <2f11576a0804042203w128d6108i58498e6b86ab87d3@mail.gmail.com>
Date: Sat, 5 Apr 2008 14:03:03 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Luck, Tony" <tony.luck@intel.com>
Subject: Re: [2.6.25-rc5-mm1][regression] ia64: hackbench doesn't finish >12 hour
Cc: "Yu, Fenghua" <fenghua.yu@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-ia64@vger.kernel.org,
       "Hidetoshi Seto" <seto.hidetoshi@jp.fujitsu.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <1FE6DD409037234FAB833C420AA843EC01011FE8@orsmsx424.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080318084314.FF0F.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <DDF46CB71CB9D647A983FECACF09A886A33019@orsmsx424.amr.corp.intel.com>
	 <20080318094527.FF12.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <DDF46CB71CB9D647A983FECACF09A886A8A6B5@orsmsx424.amr.corp.intel.com>
	 <1FE6DD409037234FAB833C420AA843EC01011FE8@orsmsx424.amr.corp.intel.com>
X-Google-Sender-Auth: 7ce5663b592b329c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  I've just pushed a new version of this patch into my test tree (so
>  it will show up in -mm and linux-next when they pull and rebuild).
>  It now uses the Piggin/Wilcox "spinaphore" primitives.  It passes
>  all my tests, and some runs of "hackbench" that tried to match the
>  tests that failed before at Fujitsu by forcing moderate amounts of
>  swapping.

Great!
