Return-Path: <linux-kernel-owner+w=401wt.eu-S1752569AbXCPXXO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569AbXCPXXO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 19:23:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752579AbXCPXXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 19:23:14 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:42202 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752569AbXCPXXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 19:23:13 -0400
Date: Sat, 17 Mar 2007 00:20:37 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Richard Knutsson <ricknu-0@student.ltu.se>
cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Kernel Janitors List <kernel-janitors@lists.osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] A need for "yesno"-function? (and "cleanup" of kernel.h)
 (was: Re: [KJ] [RFC] A need for a "yesno"-function?)
In-Reply-To: <45FAB6C5.8050302@student.ltu.se>
Message-ID: <Pine.LNX.4.61.0703170019010.23117@yvahk01.tjqt.qr>
References: <45F95351.60308@student.ltu.se> <39e6f6c70703152036m778ea054gf32723d0eda2be68@mail.gmail.com>
 <45FAB6C5.8050302@student.ltu.se>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 16 2007 16:24, Richard Knutsson wrote:
>> > 
>> > char yesno_chr(const bool value)
>> > {
>> >        return "ny"[value];
>> > }
>> > 
>> > char *yesno_str(const bool value)
>> > {
>> >        return &"no\0yes"[3 * value];
>> > }

static/extern const char *const yesno[] = {"no", "yes"};
static inline const char *yesno_str(bool value)
{
	return yesno[value];
}
#or
#define yesno_str(value) yesno[!!(value)]

>> > Thoughts?


Jan
-- 
