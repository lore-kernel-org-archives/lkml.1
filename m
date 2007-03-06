Return-Path: <linux-kernel-owner+w=401wt.eu-S1030495AbXCFJwI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030495AbXCFJwI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 04:52:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030502AbXCFJwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 04:52:08 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:19347 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030496AbXCFJwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 04:52:07 -0500
X-IronPort-AV: i="4.14,253,1170651600"; 
   d="scan'208"; a="23667335:sNHT21389368"
Subject: Re: [PATCH -mm] utrace: nommu fixup support utrace
From: "Wu, Bryan" <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: David Howells <dhowells@redhat.com>
Cc: bryan.wu@analog.com, roland@redhat.com,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <17048.1173173858@redhat.com>
References: <1173165927.17134.5.camel@roc-desktop>
	 <17048.1173173858@redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Tue, 06 Mar 2007 17:49:51 +0800
Message-Id: <1173174592.20836.0.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-06 at 09:37 +0000, David Howells wrote:
> Wu, Bryan <bryan.wu@analog.com> wrote:
> 
> > When adding utrace support to blackfin architecture, I found a compiling
> > error in nommu related utrace stuff. Then this little patch will fix
> > this for nommu arch utrace.
> 
> You really don't want to do it like this.  This prevents ELF shared libraries
> from being shared at all if UTRACE is enabled.
> 
> David

Got it, I will find another way to fix this.
Now, I just make it compile pass. 

Thanks
-Bryan
