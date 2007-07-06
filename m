Return-Path: <linux-kernel-owner+w=401wt.eu-S1764051AbXGFRc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764051AbXGFRc2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 13:32:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759970AbXGFRcV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 13:32:21 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:41395 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759960AbXGFRcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 13:32:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=hWTlUjrOqhjFW0KJ7EDAGMI5Nnl5RdInG7DKjXvvn5GnWppnQEN9OPOd5j21EF6B+ecUv6bwgXv5VYxAP3IutTAmwVlavwXd9cPffD3iCcP8dQdXsczZzEi5jlIivEcEiko5YDWZq6y0ZxqdtuWCAw0uD+mpSaP1FBdBk2XuB3U=
From: Denis Vlasenko <vda.linux@googlemail.com>
To: "Jesper Juhl" <jesper.juhl@gmail.com>
Subject: Re: kill -9?
Date: Fri, 6 Jul 2007 19:32:08 +0200
User-Agent: KMail/1.8.2
Cc: "Kaleem Khan" <linuxuser8@gmail.com>, linux-kernel@vger.kernel.org
References: <7dce480a0707052321nacc0f10x2e20171760b97705@mail.gmail.com> <9a8748490707052335i4077fec6ofe8b37e2a86e3c8e@mail.gmail.com>
In-Reply-To: <9a8748490707052335i4077fec6ofe8b37e2a86e3c8e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707061932.08878.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 July 2007 08:35, Jesper Juhl wrote:
> On 06/07/07, Kaleem Khan <linuxuser8@gmail.com> wrote:
> > Hello Kernel experts,
> >
> > I'd like to know whether there's a way to take some action (say
> > calling a routine) in
> > response to 'kill -9' before the process is terminated. I tend to
> > think it's against 'kill -9'
> > UNIX/Linux philosophy but still I'd like to confirm.
> >
> You can't catch/block SIGKILL (9), but you can catch SIGTERM (15 -
> what kill sends by default).
> 
> A well behaved app should catch SIGTERM and do proper cleanup before
> shutdown so that when a user does  kill <pid_of_app>  it shuts down
> cleanly.  kill -9 <pid_of_app> shouldn't normally be needed - it is
> for emergency termination of the app, which is why you can't catch it.

Tell that to Oracle. They believe that they are above any rules
and conventions. TERM does not terminate oracle db.

I tried to explain to Oracle DBAs I met how terribly wrong is it.
Quite frustrating experience.
--
vda
