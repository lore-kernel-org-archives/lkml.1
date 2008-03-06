Return-Path: <linux-kernel-owner+w=401wt.eu-S932355AbYCFPhg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932355AbYCFPhg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 10:37:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754697AbYCFPh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 10:37:29 -0500
Received: from wr-out-0506.google.com ([64.233.184.233]:62348 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436AbYCFPh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 10:37:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gkYXlZe+JnG8A0JMq8OoOhUYvC2QQvA821vGvBDGKL7PMUfWIvqgXH29++BteYJWfhzeHKg7Q6fXhG/IIDm0eZWMGSusPE/TwohJX5JMswnCBn7/uHYlEYxjU5dcNGgdcZL4ZULME1YPtZMD4l83mi6P4YBdmrFp98Uq/3c13zU=
Message-ID: <b609cb3b0803060737xa0c3c0byb51d51af797eb81f@mail.gmail.com>
Date: Thu, 6 Mar 2008 10:37:21 -0500
From: NightStrike <nightstrike@gmail.com>
To: "Olivier Galibert" <galibert@pobox.com>, "H. Peter Anvin" <hpa@zytor.com>,
       "Chris Lattner" <clattner@apple.com>, "Michael Matz" <matz@suse.de>,
       "Richard Guenther" <richard.guenther@gmail.com>,
       "Joe Buck" <Joe.Buck@synopsys.com>, "Jan Hubicka" <hubicka@ucw.cz>,
       "Aurelien Jarno" <aurelien@aurel32.net>, linux-kernel@vger.kernel.org,
       gcc@gcc.gnu.org
Subject: Re: RELEASE BLOCKER: Linux doesn't follow x86/x86-64 ABI wrt direction flag
In-Reply-To: <20080306135139.GA5236@dspnet.fr.eu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0803052158270.20583@wotan.suse.de>
	 <84fc9c000803051332q2f2eedeej7d3c0509e698cabf@mail.gmail.com>
	 <47CF11D6.7070901@zytor.com>
	 <738B72DB-A1D6-43F8-813A-E49688D05771@apple.com>
	 <Pine.LNX.4.64.0803052258530.20583@wotan.suse.de>
	 <2F47E21A-9055-4EC3-99CF-B666BBC045C3@apple.com>
	 <47CF3F09.4080606@zytor.com>
	 <578FCA7D-D7A6-44F6-9310-4A97C13CDCBE@apple.com>
	 <47CF44E7.3020106@zytor.com> <20080306135139.GA5236@dspnet.fr.eu.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/6/08, Olivier Galibert <galibert@pobox.com> wrote:
> On Wed, Mar 05, 2008 at 05:12:07PM -0800, H. Peter Anvin wrote:
> > It's a kernel bug, and it needs to be fixed.
>
> I'm not convinced.  It's been that way for 15 years, it's that way in
> the BSD kernels, at that point it's a feature.  The bug is in the
> documentation, nowhere else.  And in gcc for blindly trusting the
> documentation.

The issue should not be evaluated as: "It's always been that way,
therefore, it's right."  Instead, it should be: "What's the right way
to do it?"

You don't just change documentation because no existing code meets the
requirement -- UNLESS -- the non-conforming code is actually the right
way to do things.
