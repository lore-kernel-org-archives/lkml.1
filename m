Return-Path: <linux-kernel-owner+w=401wt.eu-S1756576AbYJQAk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576AbYJQAk7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 20:40:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753325AbYJQAku
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 20:40:50 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:38226 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876AbYJQAkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 20:40:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=TpkHhCwSgQQJNFaswFiSLNBY+jcYPkWw5klTmsnX81gnnTiOhbEDBYSxX+QqkrW7iK
         mfD3T3hXw9CEQ24TAIE9ySsqa30D81LJiXWhUD18qLIyVjtk892wecvtIdKnC4yZjKbs
         IeJwsoedthvcRFRjMd5nUfU2dSglyg2ayoJac=
Message-ID: <9a61df10810161740g1838c7a2me97a9a01f08c632@mail.gmail.com>
Date: Fri, 17 Oct 2008 08:40:47 +0800
From: "Lin Ming" <minggr@gmail.com>
To: "Alan Jenkins" <aj504@student.cs.york.ac.uk>
Subject: Re: Suspend/resume regression between 2.6.26 and 2.6.27-rc1
Cc: "Zhao Yakui" <yakui.zhao@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org, "Zhang Rui" <rui.zhang@intel.com>,
       "Len Brown" <lenb@kernel.org>, linux-acpi <linux-acpi@vger.kernel.org>,
       "Li, Shaohua" <shaohua.li@intel.com>, mingo@elte.hu
In-Reply-To: <48F70BE3.1050009@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1223625973.2735.142.camel@rzhang-dt>
	 <200810101441.14123.rjw@sisk.pl>
	 <1224143818.3944.68.camel@yakui_zhao.sh.intel.com>
	 <48F70BE3.1050009@tuffmail.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2008 at 5:39 PM, Alan Jenkins
<aj504@student.cs.york.ac.uk> wrote:
> There's a known fix for the kernel panic.  It's referenced at <http://bugzilla.kernel.org/show_bug.cgi?id=11237#c25>.  That should help you bisect down to a smaller range.  Hopefully you can rule out the commit that caused^Wexposed Bug #11237, which is really a nasty BIOS bug.

It's already the result after the patch you mentioned applied.
We can not bisect any more due to compile error because i386/x86_64 merge stuff.

Thanks,
Lin Ming
