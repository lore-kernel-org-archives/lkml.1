Return-Path: <linux-kernel-owner+w=401wt.eu-S1756744AbZBKKRw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744AbZBKKRw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 05:17:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754899AbZBKKRP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 05:17:15 -0500
Received: from mailservice.tudelft.nl ([130.161.131.5]:7357 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754822AbZBKKRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 05:17:14 -0500
X-Spam-Flag: NO
X-Spam-Score: -14.389
Message-ID: <4992A5A6.5000707@tremplin-utc.net>
Date: Wed, 11 Feb 2009 11:17:10 +0100
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.19) Gecko/20081231 Mandriva/2.0.0.19-1mdv2009.1 (2009.1) Thunderbird/2.0.0.19 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Pavel Machek <pavel@suse.cz>
Subject: Re: [PATCHv7] lis3lv02d: support both one- and two-byte sensors
References: <49929EB8.4020802@tremplin-utc.net> <1234346803-19811-1-git-send-email-giuseppe.bilotta@gmail.com>
In-Reply-To: <1234346803-19811-1-git-send-email-giuseppe.bilotta@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Giuseppe Bilotta schreef:
> Sensors responding with 0x3B to WHO_AM_I only have one data register per
> direction, thus returning a signed byte from the position which is
> occupied by the MSB in sensors responding with 0x3A.
> 
> Since multiple sensors share the reply to WHO_AM_I, we rename the
> defines to better indicate what they identify (family of single and
> double precision sensors).
> 
> We support both kind of sensors by checking for the sensor type on init
> and defining appropriate data-access routines and sensor limits (for the
> joystick) depending on what we find.
> 
> Signed-off-by: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
Acked-by: Eric Piel <Eric.Piel@tremplin-utc.net>

Andrew, could you queue it? This should fix problems with a certain
number of laptops which were supposedly supported but in practice were
not usable.

Thanks,
Eric
