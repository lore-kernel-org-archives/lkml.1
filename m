Return-Path: <linux-kernel-owner+w=401wt.eu-S1757365AbYFQUfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757365AbYFQUfk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 16:35:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754973AbYFQUf3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 16:35:29 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:47089 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753340AbYFQUf2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 16:35:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=tW9svm6EWO6VPKiMbmnHT5XF+W62XXgkPf4JHaWQns1iF046h93aepKiJX79ODTPP4
         URl2kKdlLZyA/DNuqFbxq7ekPb2XqgBl24hZKXh6X2vkuh1SlxuC1sp0mSW9sXkAG2oc
         J2gzCxRINm0r4NAdO2JKgQzjrHZtZEhvHIkTw=
Date: Tue, 17 Jun 2008 16:35:16 -0400
From: Josh Boyer <jwboyer@gmail.com>
To: =?ISO-8859-1?B?SvZybg==?= Engel <joern@logfs.org>
Cc: Tim Bird <tim.bird@am.sony.com>,
       linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: Recommendation for activating a deferred module init in the
 kernel
Message-ID: <20080617163516.2be96400@vader.jdub.homelinux.org>
In-Reply-To: <20080617202318.GC31224@logfs.org>
References: <48580116.9070504@am.sony.com>
	<20080617190750.GA31224@logfs.org>
	<485815F6.20507@am.sony.com>
	<485816B3.3080800@am.sony.com>
	<20080617202318.GC31224@logfs.org>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.10; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jun 2008 22:23:19 +0200
Jörn Engel <joern@logfs.org> wrote:

> On Tue, 17 June 2008 12:55:31 -0700, Tim Bird wrote:
> > 
> > Sorry - I responded too quickly.  I'm not sure I follow the
> > original suggestion.  How would I call the open function of
> > a module that is not initialized yet?
> 
> Hmm, good point.  I guess that suggestion has just failed the reality
> test.

Have a simple module that calls the initialization functions for
anything with a deferred init.  Then you can open that and use an ioctl
to...

I think if we try really really hard, we can make this a Rube-Goldberg
Machine!

josh
