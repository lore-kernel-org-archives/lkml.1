Return-Path: <linux-kernel-owner+w=401wt.eu-S1757411AbZFJSjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757411AbZFJSjq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 14:39:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757243AbZFJSjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 14:39:35 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:38843 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886AbZFJSjc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 14:39:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=QpY7sV0P/3wfjtbxiLHTXCi/tzsDBIgOzd5EYavUN65H3APE2gK0hbk+wv2vL873dl
         NrfxOJXwQpKSVHoxUSXxf0ZqPmc6f1/zTHt8zhT+DhtacXCvS/zpSb6UQV4EceSy+KEY
         2/qXdz0wd8VTm/S42pNbzYkn2vyeC+JwYymME=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0906101303560.30552@gandalf.stny.rr.com>
References: <1244623722-6325-1-git-send-email-vapier@gentoo.org> 
	<1244623722-6325-2-git-send-email-vapier@gentoo.org> <alpine.DEB.2.00.0906101303560.30552@gandalf.stny.rr.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 10 Jun 2009 14:31:28 -0400
Message-ID: <8bd0f97a0906101131m2fc21f75uc174631150897e5e@mail.gmail.com>
Subject: Re: [PATCH 2/2] ftrace: document basic ftracer/ftracer graph needs
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 10, 2009 at 13:04, Steven Rostedt wrote:
> On Wed, 10 Jun 2009, Mike Frysinger wrote:
>> While implementing ftracer and ftracer graph support, I found the exact
>> arch implementation details to be a bit lacking (and my x86 foo ain't
>> great).  So after pounding out support for the Blackfin arch, document
>> the requirements.
>
> This does not belong in the Kconfig. That's the last place a developer
> will look for implementing something.

yes and no -- i was following the existing documenting practice of
ftrace where details were added to the Kconfig.  guess i should fix
that in the process.

there should be at least tips in each HAVE_XXX as to where to look for
implementation details.
-mike
