Return-Path: <linux-kernel-owner+w=401wt.eu-S935012AbXHHOZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935012AbXHHOZW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 10:25:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934712AbXHHOYp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 10:24:45 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:60537 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935375AbXHHOYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 10:24:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=B5V0mXX++99NZVa3hL7Dm70mnT4uf7RlyIhMjjxftE+RfXuWtkUothxdqeEWXHAQBAmOjXaMcADHVFAKPgsHUHpzMK+GbjBtfq7G+lOJhOkuOoiwTD5FkJsSEZxOf5yXTod8OuNwXnCj4iRGdHQu53q4BNWwGFnXTBgzURw/SCo=
Message-ID: <5d6222a80708080724i67117252y95ac5443c46160d3@mail.gmail.com>
Date: Wed, 8 Aug 2007 11:24:41 -0300
From: "Glauber de Oliveira Costa" <glommer@gmail.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: [PATCH 21/25] [PATCH] export cpu_gdt_descr
Cc: "Glauber de Oliveira Costa" <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, mingo@elte.hu, chrisw@sous-sol.org,
       jeremy@goop.org, avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org,
       "Steven Rostedt" <rostedt@goodmis.org>
In-Reply-To: <1186572745.2862.5.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11865467522495-git-send-email-gcosta@redhat.com>
	 <11865468043920-git-send-email-gcosta@redhat.com>
	 <118654680831-git-send-email-gcosta@redhat.com>
	 <11865468122642-git-send-email-gcosta@redhat.com>
	 <11865468162812-git-send-email-gcosta@redhat.com>
	 <1186546820708-git-send-email-gcosta@redhat.com>
	 <11865468243612-git-send-email-gcosta@redhat.com>
	 <11865468321629-git-send-email-gcosta@redhat.com>
	 <11865468362401-git-send-email-gcosta@redhat.com>
	 <1186572745.2862.5.camel@laptopd505.fenrus.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/8/07, Arjan van de Ven <arjan@infradead.org> wrote:
> On Wed, 2007-08-08 at 01:19 -0300, Glauber de Oliveira Costa wrote:
> > With paravirualization, hypervisors needs to handle the gdt,
> > that was right to this point only used at very early
> > inialization code. Hypervisors are commonly modules, so make
> > it an export
> >
>
> the GDT is so deeply internal that this really ought to be a _GPL
> export..

Yes, Arjan, I agree. Thanks for noticing it.


-- 
Glauber de Oliveira Costa.
"Free as in Freedom"
http://glommer.net

"The less confident you are, the more serious you have to act."
