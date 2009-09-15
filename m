Return-Path: <linux-kernel-owner+w=401wt.eu-S1758592AbZIOTqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758592AbZIOTqw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 15:46:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758039AbZIOTqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 15:46:48 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:35326 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753555AbZIOTqr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 15:46:47 -0400
MIME-Version: 1.0
In-Reply-To: <1253043763.11643.358.camel@desktop>
References: <20090915181247.GA32167@kroah.com> <1253041976-1111-6-git-send-email-gregkh@suse.de> 
	<1253043763.11643.358.camel@desktop>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Tue, 15 Sep 2009 21:46:25 +0200
Message-ID: <ac3eb2510909151246r59decb10pfb68fd5c0cb9a63a@mail.gmail.com>
Subject: Re: [PATCH 06/20] mem_class: use minor as index instead of searching 
	the array
To: Daniel Walker <dwalker@fifo99.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 15, 2009 at 21:42, Daniel Walker <dwalker@fifo99.com> wrote:
> On Tue, 2009-09-15 at 12:12 -0700, Greg Kroah-Hartman wrote:
>> +static const struct memdev {
>> +       const char *name;
>> +       const struct file_operations *fops;
>> +       struct backing_dev_info *dev_info;
>> +} devlist[] = {
>> +       [ 1] = { "mem", &mem_fops, &directly_mappable_cdev_bdi },
>
> This patch has several checkpatch errors wrt. the spacing used in the
> array index..
>
> Kay, can you send a follow up patch to correct them?

I think they are fine, and properly aligned to be best readable.

Thanks,
Kay
