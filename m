Return-Path: <linux-kernel-owner+w=401wt.eu-S1752852AbZI2OQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852AbZI2OQf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 10:16:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752812AbZI2OQd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 10:16:33 -0400
Received: from bamako.nerim.net ([62.4.17.28]:52130 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752656AbZI2OQb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 10:16:31 -0400
Date: Tue, 29 Sep 2009 16:16:29 +0200
From: Jean Delvare <khali@linux-fr.org>
To: =?UTF-8?B?UGF3ZcWC?= Sikora <pluto@agmk.net>
Cc: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
       LMML <linux-media@vger.kernel.org>
Subject: Re: [2.6.31] ir-kbd-i2c oops.
Message-ID: <20090929161629.2a5c8d30@hyperion.delvare>
In-Reply-To: <200909161003.33090.pluto@agmk.net>
References: <200909160300.28382.pluto@agmk.net>
	<20090916085701.6e883600@hyperion.delvare>
	<200909161003.33090.pluto@agmk.net>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Sep 2009 10:03:32 +0200, Paweł Sikora wrote:
> On Wednesday 16 September 2009 08:57:01 Jean Delvare wrote:
> > Hi Pawel,
> > 
> > I think this would be fixed by the following patch:
> > http://patchwork.kernel.org/patch/45707/
> 
> still oopses. this time i've attached full dmesg.

Any news on this? Do you have a refined list of kernels which have the
bug and kernels which do not? Tried 2.6.32-rc1? Tried the v4l-dvb
repository?

Anyone else seeing this bug?

Your kernel stack trace doesn't look terribly reliable and I am not
able to come to any conclusion. The crash is supposed to happen in
ir_input_init(), but the stack trace doesn't lead there. I am also
skeptical about the +0x64/0x1a52, ir_input_init() is a rather small
function and I fail to see how it could be 6738 bytes in binary size.
Might be that the bug caused a stack corruption. Building a debug
kernel may help.

-- 
Jean Delvare
