Return-Path: <linux-kernel-owner+w=401wt.eu-S2992731AbXDDIPX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992731AbXDDIPX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 04:15:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992733AbXDDIPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 04:15:22 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:45095 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992731AbXDDIO4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 04:14:56 -0400
Date: Wed, 4 Apr 2007 10:12:06 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: "Antonino A. Daplas" <adaplas@gmail.com>
cc: Martin Mares <mj@ucw.cz>, Paul LeoNerd Evans <leonerd@leonerd.org.uk>,
       Andrew Morton <akpm@osdl.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vt: Do not clear UTF when resetting console
In-Reply-To: <1175665364.4519.10.camel@daplas>
Message-ID: <Pine.LNX.4.61.0704041011520.10155@yvahk01.tjqt.qr>
References: <46110F88.5040905@gmail.com>  <mj+md-20070403.114037.27180.nikam@ucw.cz>
 <20070403145151.GN26707@cel.leo>  <mj+md-20070403.153720.5293.nikam@ucw.cz>
 <1175665364.4519.10.camel@daplas>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 4 2007 13:42, Antonino A. Daplas wrote:
>> 
>> > Does whatever defines what these escapes mean, have any comment to make
>> > about UTF-8? If not, why can't we declare that UTF-8 mode is the "reset"
>> > mode, the default that would be dropped to on a full reset, and if
>> > anyone wanted to switch that out to non-default not-UTF-8 mode, they
>> > could, but that a reset will always reenable it again..?
>> 
>> Maybe it would be a little bit more convenient, but I doubt that such
>> bit of convenience justifies breaking backward compatibility.
>
>Please note that I have dropped this patch in favor of this one:
>
>http://lkml.org/lkml/2007/4/2/422

^^ Which is ok by me.



Jan
-- 
