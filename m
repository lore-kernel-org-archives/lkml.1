Return-Path: <linux-kernel-owner+w=401wt.eu-S1752272AbZGTQsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272AbZGTQsg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 12:48:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751983AbZGTQsf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 12:48:35 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57118 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751544AbZGTQsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 12:48:35 -0400
Date: Mon, 20 Jul 2009 17:49:41 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rafael Almeida <almeidaraf@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: using ioctl to change the interface's IP
Message-ID: <20090720174941.6251bbcf@lxorguk.ukuu.org.uk>
In-Reply-To: <6de6b1650907200939t471bbb49m5d10f343267faee2@mail.gmail.com>
References: <6de6b1650907200939t471bbb49m5d10f343267faee2@mail.gmail.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Jul 2009 13:39:21 -0300
Rafael Almeida <almeidaraf@gmail.com> wrote:

> Hello,
> 
> I was studying ioctl recently and I found out that, in order to change
> the IP of a certain interface, you have to create a dummy socket with
> socket(2) and use the returned file descriptor in the ioctl call. That
> seems strange to me because the IP is not changed only for that
> particular descriptor, but globally. Why wasn't a new system call
> created for handling situations such as that?

You would have to ask the people who invented the Unix interface in
question about thirty years ago 
