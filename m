Return-Path: <linux-kernel-owner+w=401wt.eu-S1756126AbYDQXZJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126AbYDQXZJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 19:25:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754859AbYDQXYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 19:24:55 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:42057 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754362AbYDQXYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 19:24:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=JAw/rr5Mnbwwkf+4Ugkf4c1VjuHQvbsUXfr18tWPU107BIMeyY/x8f/pTrImQCLKRBKeDJwP3ardGj0/FxceFCe5qzWq0w6BnYgZ2E9IKAwLYbu+l8w7YNhbjAiHbOXtr0L77V10jerH0RbGmCeVuOwxWw8bxIpTgs9Kt3Y8YTk=
Message-ID: <e9c3a7c20804171624n43a3665dkfea4d474aac4c99e@mail.gmail.com>
Date: Thu, 17 Apr 2008 16:24:48 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.25-mm1: not looking good
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       "James Morris" <jmorris@namei.org>,
       "Stephen Smalley" <sds@tycho.nsa.gov>
In-Reply-To: <20080417160331.b4729f0c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080417160331.b4729f0c.akpm@linux-foundation.org>
X-Google-Sender-Auth: b2ac7256957282dd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2008 at 4:03 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>
>  I repulled all the trees an hour or two ago, installed everything on an
>  8-way x86_64 box and:
>
>
[..]
>  more usb/sysfs:
>
>  hub 2-0:1.0: USB hub found
>  hub 2-0:1.0: 2 ports detected
>  sysfs: duplicate filename '189:128' can not be created
[..]
>  I have maybe two hours in which to weed out whatever very-recently-added
>  dud patches are causing this.  Any suggestions are welcome.
>

The duplicate filename <major>:<minor> messages are coming from
"sysfs-add-sys-dev-char-block-to-lookup-sysfs-path-by-major-minor.patch"
now in Greg's tree.  I'll take a look.

--
Dan
