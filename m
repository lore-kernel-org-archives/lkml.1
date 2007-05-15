Return-Path: <linux-kernel-owner+w=401wt.eu-S1760649AbXEOX02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760649AbXEOX02 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 19:26:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757031AbXEOX0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 19:26:19 -0400
Received: from nz-out-0506.google.com ([64.233.162.225]:39744 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756746AbXEOX0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 19:26:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=AuQVERaw07lU5t/loWe4I7QKmNcT6lu0cCWbYTAs0cV2CwSL2H5lRdnme0Aj70yAC7rPMeyE+AW82kl8QGSUsA8/xfTh9sPe/d0YgYoD5lbXVNcdk/SnbSgOxGa5PUWVUyCM/GNoSLCXDO11B2Ef3GUlGm2ulslfj7bVQe062PI=
Message-ID: <787b0d920705151626x3a11b81csf0f3747a695131b0@mail.gmail.com>
Date: Tue, 15 May 2007 19:26:17 -0400
From: "Albert Cahalan" <acahalan@gmail.com>
To: "=?ISO-8859-1?Q?J=F6rn_Engel?=" <joern@lazybastard.org>
Subject: Re: [PATCH] LogFS take three
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, akpm@osdl.org,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Jan Engelhardt" <jengelh@linux01.gwdg.de>,
       "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>, "Greg KH" <greg@kroah.com>,
       "Ingo Oeser" <ioe-lkml@rameria.de>
In-Reply-To: <20070515151919.GA32510@lazybastard.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070515151919.GA32510@lazybastard.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Please don't forget the immutable bit. ("man lsattr")
Having both, BSD-style, would be even better.
The immutable bit is important for working around
software bugs and "features" that damage files.

I also can't find xattr support.
