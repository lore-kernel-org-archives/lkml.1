Return-Path: <linux-kernel-owner+w=401wt.eu-S1759896AbYDDPJw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759896AbYDDPJw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 11:09:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756717AbYDDPJo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 11:09:44 -0400
Received: from ti-out-0910.google.com ([209.85.142.186]:32673 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134AbYDDPJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 11:09:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=G/5jvJ0Sri0c2p+SuquYwNgfYpRFE/mcC8pgTY8tSL3CgfSLNvEqh46up2xtZafnP6Eah1OriiFURZa6GNwG303ei/+QcJxt6NcDCvrAR/WXeELYqugy4J6zVWC/C9Wo4L5HequdHitpSwJFNWg49+35y3FGukYFpzC4rXBg5bI=
Message-ID: <37219a840804040809q470a64fdmed95e21bd51c23b0@mail.gmail.com>
Date: Fri, 4 Apr 2008 11:09:38 -0400
From: "Michael Krufky" <mkrufky@linuxtv.org>
To: harvey.harrison@gmail.com
Subject: Re: [v4l-dvb-maintainer] [PATCH] media: replace remaining __FUNCT ION__ occurences
Cc: akpm@linux-foundation.org, v4l-dvb-maintainer@linuxtv.org,
       linux-kernel@vger.kernel.org, abraham.manu@gmail.com,
       mchehab@infradead.org
In-Reply-To: <47F536FF.8060105@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1204613661.22933.110.camel@brick> <47F536FF.8060105@linuxtv.org>
X-Google-Sender-Auth: 75cba98b44133dd4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 3, 2008 at 3:58 PM,  <mkrufky@linuxtv.org> wrote:
>  Harvey,
>
>  If you decide to move forward with these cleanups now, please keep the
>  previous discussion in mind -- please generate the changesets against
>  the v4l-dvb master repository, hosted on linuxtv.org, and please
>  separate the changesets by each level of the directory tree hierarchy.

Harvey,

You sent in three patches, video/ , common/ , and dvb/ ... but these
patches are way too large.

Please break these down by each level of the directory tree hierarchy,
like I asked previously.

Make one patch for files inside media/video/*.[ch]
make one patch for files inside media/video/cx88/*.[ch]
make one patch for files inside media/video/saa7134/*.[ch]
[...]
make one patch for files inside media/dvb/b2c2/*.[ch]
make one patch for files inside media/dvb/frontends/*.[ch]
[...]
etc.

-Mike
