Return-Path: <linux-kernel-owner+w=401wt.eu-S1758020AbZBDT14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758020AbZBDT14 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 14:27:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751958AbZBDT1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 14:27:46 -0500
Received: from fifo99.com ([67.223.236.141]:60361 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468AbZBDT1q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 14:27:46 -0500
Subject: Re: [crash] af9005_usb_module_init(): BUG: unable to handle kernel
	paging request at ff100000
From: Daniel Walker <dwalker@fifo99.com>
To: Luca Olivetti <luca@ventoso.org>
Cc: Ingo Molnar <mingo@elte.hu>, Greg KH <gregkh@suse.de>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-kernel@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
       Janne Grunau <janne-dvb@grunau.be>
In-Reply-To: <20090204194119.62451733@noname>
References: <20090203172836.GA6964@elte.hu>
	 <1233772258.15119.106.camel@desktop>  <20090204194119.62451733@noname>
Content-Type: text/plain
Date: Wed, 04 Feb 2009 11:27:42 -0800
Message-Id: <1233775662.15119.112.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-02-04 at 19:41 +0100, Luca Olivetti wrote:

> 
> I was going to ask the same question.
> Maybe the crash is somewhere else?

Yeah, it sort of looks that way .. It looks like the three
symbol_request() values are NULL , and it has checks to see if they are
NULL. It doesn't look possible to get to the crash line from inside the
function.. 

Daniel

