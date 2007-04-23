Return-Path: <linux-kernel-owner+w=401wt.eu-S1030972AbXDWDSJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030972AbXDWDSJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 23:18:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030982AbXDWDSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 23:18:09 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:15502 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030981AbXDWDSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 23:18:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HwkVcvPCGzYiXVc4Nix5BcFTiiF0fKB93vXDOHpi6zOCsXKVffOfp5xHUOKK3sL91/YlaYBTsHxYlj0CBqCHEmWOs53D/YAN01XOmUku2VetrBcvz99AQmNlIHpo7kLX5mpcWlNToc6fN2KJYK4Ji0VcvtoTzU/D6nxDfVMUmCM=
Message-ID: <a781481a0704222018o65f34f79gb1ffe521b83d481f@mail.gmail.com>
Date: Mon, 23 Apr 2007 08:48:04 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Paul Jackson" <pj@sgi.com>
Subject: Re: [RFC][PATCH -mm 2/3] freezer: Introduce freezer_flags
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, akpm@linux-foundation.org,
       mingo@elte.hu, ego@in.ibm.com, oleg@tv-sign.ru,
       linux-kernel@vger.kernel.org, vatsa@in.ibm.com, paulmck@us.ibm.com,
       pavel@ucw.cz
In-Reply-To: <20070422153111.8f8837c0.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070419120131.GB13435@in.ibm.com>
	 <200704222139.27128.rjw@sisk.pl> <20070422141452.a7855599.pj@sgi.com>
	 <200704230014.42100.rjw@sisk.pl> <20070422153111.8f8837c0.pj@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/23/07, Paul Jackson <pj@sgi.com> wrote:
> One more question - why would I want to do this?

Check out the FAQ in Documentation/power/swsusp.txt.

> Is this like something that would be useful on a laptop, to suspend
> activity and reduce battery drain, while preserving the current state
> of ones sessions and avoiding having to logout or shutdown?

Yes, the original purpose for the inclusion of the freezer code was to
support suspend-resume (mainly for laptops, but suspend-resume could
be useful in other circumstances too, see the FAQ).

> Is it useful for quietting a system down before doing hot plug or
> unplug of key components, such as processors and memory?

Yes, the freezer is (proposed to be, at least) moving on from being
merely a suspend-resume-only thing to other usage scenarios, such as
kprobes and hotlpug.
