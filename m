Return-Path: <linux-kernel-owner+w=401wt.eu-S1754631AbYKYAqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631AbYKYAqT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 19:46:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754112AbYKYAqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 19:46:12 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:14345 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754107AbYKYAqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 19:46:12 -0500
Message-ID: <154e089b0811241646y6ada2c97l5e45284969729e29@mail.gmail.com>
Date: Tue, 25 Nov 2008 01:46:10 +0100
From: "Hannes Eder" <hannes@hanneseder.net>
To: "David Howells" <dhowells@redhat.com>
Subject: Re: [PATCH] CRED: fix sparse warnings
Cc: "James Morris" <jmorris@namei.org>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
In-Reply-To: <5008.1227568869@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <154e089b0811241314t3291ea30w6268bb5b2b5c7c53@mail.gmail.com>
	 <5008.1227568869@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2008 at 12:21 AM, David Howells <dhowells@redhat.com> wrote:
> Hannes Eder <hannes@hanneseder.net> wrote:
>
>>   security/security.c:228:2: warning: returning void-valued expression
>>   security/security.c:233:2: warning: returning void-valued expression
>>   security/security.c:616:2: warning: returning void-valued expression
>
> What's wrong with that?

In my opinion the following quotes give good argument:

> On Thu, 2008-05-01 at 13:00 +0100, Al Viro wrote:
[snip|
> > 3.  6.8.6.4(1): A return statement with an expression shall not appear in
> > a function whose return type is void.
> >
> > Write in C, please.

see http://lkml.org/lkml/2008/5/1/88

On Thu, 1 May 2008 at 13:53:39 +0100, Al Viro wrote:
> On Thu, May 01, 2008 at 03:42:14PM +0300, Boaz Harrosh wrote:
> > > 3.  6.8.6.4(1): A return statement with an expression shall not appear in
> > > a function whose return type is void.
> > >
> >
> > Please forgive my ignorance, where is this quote from?
>
> C99.  I don't have C90 in front of me, so I can't give you exact quote from
> there, but it's been explicitly banned in C90 as well.

see http://lkml.org/lkml/2008/5/1/112

There have been a couple of such patches, see

http://www.google.at/search?q=site:lkml.org+%22warning:+returning+void-valued+expression%22

Furthermore in the next-tree from today and 'defconfig' are only 5 of
such warnings left, 3 of them would be resolved with this patch.

Hannes
