Return-Path: <linux-kernel-owner+w=401wt.eu-S1754970AbXLSC4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754970AbXLSC4R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 21:56:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751672AbXLSC4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 21:56:05 -0500
Received: from nz-out-0506.google.com ([64.233.162.235]:35885 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbXLSC4D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 21:56:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jrHnwGqA/dwvbcronzgC/ZkW9h8L+3Xb9u8xvalyFlTIEWMNZJN+YV7PGFSRVzaMYlBnf4+KbFXCPbp5LXkLs1zpDs69QFn0LKBjZUAOnso6x0MRKvEuGK64+e2tyu+Jc3X9njbh+ptz7n3ulolV6n5nDPS4kfLqaoj059+gXHg=
Message-ID: <5d6222a80712181856l4f24104ei38ecd2e9f0c6422e@mail.gmail.com>
Date: Wed, 19 Dec 2007 00:56:01 -0200
From: "Glauber de Oliveira Costa" <glommer@gmail.com>
To: "Frans Pop" <elendil@planet.nl>
Subject: Re: [PATCH] finish processor.h integration
Cc: "Glauber de Oliveira Costa" <gcosta@redhat.com>, ak@suse.de,
       akpm@linux-foundation.org, anthony@codemonkey.ws, avi@qumranet.com,
       chrisw@sous-sol.org, ehabkost@redhat.com, hpa@zytor.com,
       jeremy@goop.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       roland@redhat.com, rostedt@goodmis.org, rusty@rustcorp.com.au,
       tglx@linutronix.de, virtualization@lists.linux-foundation.org,
       zach@vmware.com
In-Reply-To: <200712182232.45685.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <1198008293639-git-send-email-gcosta@redhat.com>
	 <E1J4jSf-00024X-GN@faramir.fjphome.nl>
	 <5d6222a80712181300l707035e7mdb8a6e0d7a5ddca8@mail.gmail.com>
	 <200712182232.45685.elendil@planet.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 18, 2007 7:32 PM, Frans Pop <elendil@planet.nl> wrote:
> On Tuesday 18 December 2007, Glauber de Oliveira Costa wrote:
> > On Dec 18, 2007 6:54 PM, Frans Pop <elendil@planet.nl> wrote:
> > > Glauber de Oliveira Costa wrote:
> > > > What's left in processor_32.h and processor_64.h cannot be cleanly
> > > > integrated. However, it's just a couple of definitions. They are
> > > > moved to processor.h around ifdefs, and the original files are
> > > > deleted. Note that there's much less headers included in the final
> > > > version.
> > >
> > > Either I must be missing something or this patch was corrupted somehow.
> >
> > neither.
> > Note the else in the middle. It's just a mistake in the comment.
>
> Wouldn't an explicit second #ifdef block be a lot clearer (and improve
> maintainability) in this case?
>
> An #else can easily be overlooked among other preprocessor commands or when
> #ifdefs get nested.
>
I don't think so. a if-then-else kind of construction is very common,
well expected, and heavily used in kernel.
But even if I´m not right, this is functionally correct, and can be
addressed in a later cleanup patch if you really want to.


-- 
Glauber de Oliveira Costa.
"Free as in Freedom"
http://glommer.net

"The less confident you are, the more serious you have to act."
