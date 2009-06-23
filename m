Return-Path: <linux-kernel-owner+w=401wt.eu-S1757792AbZFWQAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757792AbZFWQAb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 12:00:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753049AbZFWQAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 12:00:16 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54100 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752584AbZFWQAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 12:00:15 -0400
Date: Tue, 23 Jun 2009 17:01:41 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Alexander Holler <holler@ahsoftware.de>,
       Robert Hancock <hancockrwd@gmail.com>, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartmann <greg@kroah.com>
Subject: Re: asynchronous calls an the lack of --wait-for-completion options
  (e.g. modprobe, losetup, cryptsetup)
Message-ID: <20090623170141.41fe1565@lxorguk.ukuu.org.uk>
In-Reply-To: <ac3eb2510906230435r6489ddafqb15214f190d4eae8@mail.gmail.com>
References: <4A38F229.70504@ahsoftware.de>
	<4A3AE162.7040407@gmail.com>
	<ac3eb2510906201220v7fc1d51ve4a9937a3d73d3d4@mail.gmail.com>
	<4A3F7440.3030603@ahsoftware.de>
	<ac3eb2510906230435r6489ddafqb15214f190d4eae8@mail.gmail.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jun 2009 13:35:07 +0200
Kay Sievers <kay.sievers@vrfy.org> wrote:

> On Mon, Jun 22, 2009 at 14:08, Alexander Holler<holler@ahsoftware.de> wrote:
> > On 20.06.2009 21:20, Kay Sievers wrote:
> 
> > Anyway, I still think, that the creation of the device-node is (seen from a
> > user-point) part of the module-initialization or part of the operation of
> > the userland-tool (like modprobe, losetup or cryptsetup). So in my point of
> > view, they should at least offer an option to wait until udev finished that
> > operation and should not rely on the user to call udevadm.
> 
> That would be all solved properly by "devtmpfs":
>    http://lkml.org/lkml/2009/4/30/182

which unsolves lots of other problems and has good reasons why people
object to it.

Sorting out waiting behaviour and fixing udev to do jobs once is a user
space problem and while it might benefit from some tiny bits of kernel
help re-implementing devfs (which we've been through before thank you) is
not the cure but replacing a minor ailment with a nasty disease
