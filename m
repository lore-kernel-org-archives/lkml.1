Return-Path: <linux-kernel-owner+w=401wt.eu-S1757392AbXEIMOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757392AbXEIMOS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 08:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756054AbXEIMNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 08:13:49 -0400
Received: from ik-out-1112.google.com ([66.249.90.181]:59298 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024AbXEIMNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 08:13:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=jD1RAobtmthLNcGkUlcuQ0VWBiV+yZLFZjRzWsVse/IJi1U4xbLWE0el8o/HK6Gac/8iMUiHmJ0onAy71A95KDlC+QOf+bJko6j2xOl+IgoMkB/bv2yqj/irheGTE47G9p89mYuMciI8IHnHT7lBHvtRUFV5WxUYQjj9+cbiyv4=
Message-ID: <84144f020705090513q28784b69sd91cd2490514d44c@mail.gmail.com>
Date: Wed, 9 May 2007 15:13:45 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Rusty Russell" <rusty@rustcorp.com.au>
Subject: Re: [patch 2/9] lguest: the guest code
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org, ak@suse.de,
       jeremy@goop.org
In-Reply-To: <1178711957.7286.87.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200705090951.l499pYBV020391@shell0.pdx.osdl.net>
	 <84144f020705090316o5e3b6d89r74638ec8e4d396d4@mail.gmail.com>
	 <1178711957.7286.87.camel@localhost.localdomain>
X-Google-Sender-Auth: 0a734cef04611461
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty,

On 5/9/07, Rusty Russell <rusty@rustcorp.com.au> wrote:
>         Hmm, where would the error go?

Let it propagate: scan_devices -> lguest_bus_init -> do_initcalls. We
probably don't want to panic() if bus_register and device_register
fail there either.
