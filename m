Return-Path: <linux-kernel-owner+w=401wt.eu-S1752034AbXCDR3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034AbXCDR3W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 12:29:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752064AbXCDR3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 12:29:22 -0500
Received: from stout.engsoc.carleton.ca ([134.117.69.22]:56686 "EHLO
	stout.engsoc.carleton.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034AbXCDR3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 12:29:21 -0500
Date: Sun, 4 Mar 2007 12:28:42 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: Mockern <Mockern@yandex.ru>
Cc: linux-kernel@vger.kernel.org
Subject: Re: kernel threads locking data
Message-ID: <20070304172842.GA29277@athena.road.mcmartin.ca>
References: <45EAFC30.000004.20012@webmail14.yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45EAFC30.000004.20012@webmail14.yandex.ru>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 04, 2007 at 08:04:48PM +0300, Mockern wrote:
> hi,
> 
> how is better to lock data (a buffer) which is used by 2 kernel threads?
> 

if it's only used by the threads, and not by anything running in interrupt
context, use a mutex.

Documentation/mutex-design.txt has most of the info you'd need.

Cheers,
	Kyle
