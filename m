Return-Path: <linux-kernel-owner+w=401wt.eu-S1754157AbYFQPrD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157AbYFQPrD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 11:47:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751819AbYFQPqv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 11:46:51 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57507 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751603AbYFQPqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 11:46:50 -0400
Date: Tue, 17 Jun 2008 16:29:10 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Martin Michlmayr <tbm@cyrius.com>
Cc: Anthony Liguori <anthony@codemonkey.ws>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Linux with kvm-intel locks up VMplayer guest is started
Message-ID: <20080617162910.4019bf01@lxorguk.ukuu.org.uk>
In-Reply-To: <20080617133234.GE2397@deprecation.cyrius.com>
References: <20080616150550.GA16086@deprecation.cyrius.com>
	<48568503.90607@codemonkey.ws>
	<20080617123918.GA2397@deprecation.cyrius.com>
	<4857B92F.9020309@codemonkey.ws>
	<20080617133234.GE2397@deprecation.cyrius.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.8; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jun 2008 15:32:34 +0200
Martin Michlmayr <tbm@cyrius.com> wrote:

> * Anthony Liguori <anthony@codemonkey.ws> [2008-06-17 08:16]:
> > VMware is a binary kernel module that's out of kernel.  KVM is not
> > misbehaving and the fact that VMware breaks when the KVM module is
> > loaded isn't our problem.  If they submitted their code for
> > inclusion in  mainline, we could possibly come up with solution for
> > arbitrating who is  using VT.
> 
> I feared I'd get a response like this.  But unless this is a known
> issue in VMware (which I don't think it is), you don't know whether
> it's not a bug in kvm-intel.

So ask vmware. They have source to both parts we don't.

And its a bug in vmware by definition. If the emulator differs from the
real thing then the emulator is at fault. It might well be that the limit
is a genuine technical limit - but its still an emulator fault.

Alan
