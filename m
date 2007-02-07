Return-Path: <linux-kernel-owner+w=401wt.eu-S1161452AbXBGWJI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161452AbXBGWJI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 17:09:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422787AbXBGWJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 17:09:08 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:29389 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161452AbXBGWJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 17:09:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=gwBcTUMmrQU5EID4ZLCREEnL8QGCHWaENxxwXFp2H8IGQlMyCceqf+QkSJlqDFW/mh2cQY58kleFxcIHqFyprrzqqbONrXI+VZXEAefgyi0Q+UXewU7yIxTuMr3Gvip2AbIhezN4xaxWwYgSDM/w+17eQGKkdsPMqv3DVKWIB+I=
Message-ID: <b6c5339f0702071408g70fd3cbcvc8039245bbd99bb7@mail.gmail.com>
Date: Wed, 7 Feb 2007 17:08:51 -0500
From: "Bob Copeland" <me@bobcopeland.com>
To: "Alan Stern" <stern@rowland.harvard.edu>
Subject: Re: [PATCH] Kwatch: kernel watchpoints using CPU debug registers
Cc: "Roland McGrath" <roland@redhat.com>,
       "Prasanna S Panchamukhi" <prasanna@in.ibm.com>,
       "Kernel development list" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.0702071356580.4502-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070207025008.1B11118005D@magilla.sf.frob.com>
	 <Pine.LNX.4.44L0.0702071356580.4502-100000@iolanthe.rowland.org>
X-Google-Sender-Auth: 696adb153d720203
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/7/07, Alan Stern <stern@rowland.harvard.edu> wrote:
> I wonder where this convention of using lower numbers to indicate higher
> priorities comes from...  It seems to be quite prevalent even though it's
> obviously backwards.

I agree but at least in the case of 'nice' it works in the sense that
the value increases with increasing niceness.  Done the other way,
they would have to call it 'mean,' then someone would wonder why 'mean
10 20' prints 'No such file or directory' instead of '15'...

Bob
