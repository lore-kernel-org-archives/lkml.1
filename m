Return-Path: <linux-kernel-owner+w=401wt.eu-S1761305AbXHGMbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761305AbXHGMbq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 08:31:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754718AbXHGMbg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 08:31:36 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:18380 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbXHGMbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 08:31:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=oQqR1dVxK+saiw1+Tjv6xCYvfUlnSEBNwOXBsmQe8enaUjhPuMhxB9hS6sRzbwQyzk1jrxFbJFnnt87OKxx1t+mpUfSEnRATr5hdb9EvUF3qGj3ujFEJWgzxf6IQcBS/YTtPkpyy2uJuHCWeTkuWN51CmfEOtlEEL/SXMFYtWvY=
Message-ID: <3ae72650708070531q696625ddo6e7f582693c8267@mail.gmail.com>
Date: Tue, 7 Aug 2007 14:31:34 +0200
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Cornelia Huck" <cornelia.huck@de.ibm.com>
Subject: Re: [PATCH] request_firmware: skip timeout if userspace was not notified
Cc: "Javier Pello" <javier.pello@urjc.es>, linux-kernel@vger.kernel.org,
       "Greg KH" <greg@kroah.com>
In-Reply-To: <20070807141030.1bb0f76a@gondolin.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46B37CF7.2020803@urjc.es>
	 <20070806142451.5d28d41c@gondolin.boeblingen.de.ibm.com>
	 <46B7832B.6010808@urjc.es>
	 <20070807125844.4d756b04@gondolin.boeblingen.de.ibm.com>
	 <3ae72650708070446y6452d13jb7cd802119dab3ce@mail.gmail.com>
	 <20070807141030.1bb0f76a@gondolin.boeblingen.de.ibm.com>
X-Google-Sender-Auth: b7194fd88cfff4c3
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/7/07, Cornelia Huck <cornelia.huck@de.ibm.com> wrote:
> On Tue, 7 Aug 2007 13:46:55 +0200,
> "Kay Sievers" <kay.sievers@vrfy.org> wrote:
>
> > > - Use an extra parameter in which successful delivery can be indicated.
> > > Make this
> > > int kobject_uevent_env_check(struct kobject *kobject,
> > >                              enum kobject_action action,
> > >                              char *envp[], int delivered);
> > > so existing callers that don't care don't have to be changed.
> >
> > How do you check if events have been "handled"? None of the recent
> > distros uses /sbin/hotplug anymore. Netlink events are broadcasted,
> > but no failure in delivery doesn't mean anything like "handled", or
> > delivered to the right instance. Even if you check that the netlink
> > socket has listeners, that wouldn't be sufficient to tell that is is
> > handled.
>
> You can't check if it's been handled, yes; but you can certainly check
> if you delivered it.

The broadcast returns a failure when nobody received the message?

Kay
