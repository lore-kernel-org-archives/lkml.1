Return-Path: <linux-kernel-owner+w=401wt.eu-S1755854AbZIOUGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755854AbZIOUGW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 16:06:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752950AbZIOUGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 16:06:18 -0400
Received: from fifo99.com ([67.223.236.141]:38362 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752755AbZIOUGR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 16:06:17 -0400
Subject: Re: [PATCH 06/20] mem_class: use minor as index instead of
 searching  the array
From: Daniel Walker <dwalker@fifo99.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
In-Reply-To: <ac3eb2510909151246r59decb10pfb68fd5c0cb9a63a@mail.gmail.com>
References: <20090915181247.GA32167@kroah.com>
	 <1253041976-1111-6-git-send-email-gregkh@suse.de>
	 <1253043763.11643.358.camel@desktop>
	 <ac3eb2510909151246r59decb10pfb68fd5c0cb9a63a@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 15 Sep 2009 13:07:09 -0700
Message-Id: <1253045229.11643.398.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-15 at 21:46 +0200, Kay Sievers wrote:
> On Tue, Sep 15, 2009 at 21:42, Daniel Walker <dwalker@fifo99.com> wrote:
> > On Tue, 2009-09-15 at 12:12 -0700, Greg Kroah-Hartman wrote:
> >> +static const struct memdev {
> >> +       const char *name;
> >> +       const struct file_operations *fops;
> >> +       struct backing_dev_info *dev_info;
> >> +} devlist[] = {
> >> +       [ 1] = { "mem", &mem_fops, &directly_mappable_cdev_bdi },
> >
> > This patch has several checkpatch errors wrt. the spacing used in the
> > array index..
> >
> > Kay, can you send a follow up patch to correct them?
> 
> I think they are fine, and properly aligned to be best readable.

We already have a coding style in Linux which doesn't allow this type of
alignment .. If we allowed everyone to pick their own coding style we
would have a pretty ugly looking kernel.. That's why the checkpatch tool
was create to test for style conformance.. If you feel strongly about
this alignment you could change checkpatch not to warn on this , but I
don't think it's likely a change like that would be accepted..

Daniel

