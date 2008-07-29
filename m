Return-Path: <linux-kernel-owner+w=401wt.eu-S1754502AbYG2C6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502AbYG2C6b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 22:58:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752032AbYG2C6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 22:58:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44090 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752003AbYG2C6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 22:58:20 -0400
Date: Mon, 28 Jul 2008 19:58:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ben Collins <ben.collins@canonical.com>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-usb@vger.kernel.org
Subject: Re: [PATCH 5/7] [airprime] Add support for more devices
Message-Id: <20080728195813.6c51450b.akpm@linux-foundation.org>
In-Reply-To: <E1KKl4J-00068N-2b@swissweb.swissdisk.com>
References: <24762.90.138.930.038.1036103001.ben.collins@canonical.com>
	<E1KKl4J-00068N-2b@swissweb.swissdisk.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Jul 2008 21:54:48 -0400 Ben Collins <ben.collins@canonical.com> wrote:

> Reference: https://launchpad.net/bugs/208250
> 
> Add support for:
> - Audiovox PC5740
> - Huawei E220
> - Momo design
> - AirPrime 5220
> - Dell Wireless HSDPA 5500
> - Sprint Pantech PX-500
> - Novatel U727
> - Onda MT505UP

airprime.c got deleted.

  commit 640c1bce86d1e11ee6a1263fdf6170d3210b1684
  Author: Greg Kroah-Hartman <gregkh@suse.de>
  Date:   Thu Jun 19 11:21:16 2008 -0700

      USB: delete airprime driver
    
      This driver is only for one device id, and the option driver should be
      used instead for it.

It'd be good if we can verify that the option driver presently supports
all these new devices.

