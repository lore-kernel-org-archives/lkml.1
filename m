Return-Path: <linux-kernel-owner+w=401wt.eu-S1751373AbXBUXxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751373AbXBUXxS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 18:53:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751372AbXBUXxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 18:53:18 -0500
Received: from scrub.xs4all.nl ([194.109.195.176]:38489 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751373AbXBUXxR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 18:53:17 -0500
From: Roman Zippel <zippel@linux-m68k.org>
To: Rodolfo Giometti <giometti@enneenne.com>
Subject: Re: [PATCH 1/1] LinuxPPS: Pulse per Second support for Linux
Date: Thu, 22 Feb 2007 00:51:48 +0100
User-Agent: KMail/1.9.5
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       linuxpps@ml.enneenne.com
References: <20070216185230.GO8882@enneenne.com> <45DA6354.3000305@zytor.com> <20070221120426.GJ4641@enneenne.com>
In-Reply-To: <20070221120426.GJ4641@enneenne.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702220051.49106.zippel@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wednesday 21 February 2007 13:04, Rodolfo Giometti wrote:

> RFC simply doesn't consider the fact that you can have a PPS source
> __without__ a filedes connected with, and a single filedes is
> considered __always__ connected with a single PPS source.

That's not entirely true. It doesn't say that pps_handle_t must be a file 
descriptor and it leaves the option for the argument to time_pps_create() not 
to be a file descriptor as well.

bye, Roman
