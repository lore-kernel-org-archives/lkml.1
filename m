Return-Path: <linux-kernel-owner+w=401wt.eu-S1760116AbYCDFcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760116AbYCDFcV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 00:32:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752512AbYCDFcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 00:32:12 -0500
Received: from mail.work.de ([212.12.32.20]:45862 "EHLO mail.work.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752495AbYCDFcM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 00:32:12 -0500
X-Greylist: delayed 882 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Mar 2008 00:32:11 EST
Message-ID: <47CCDB5F.1040007@gmail.com>
Date: Tue, 04 Mar 2008 09:17:19 +0400
From: Manu Abraham <abraham.manu@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Michael Krufky <mkrufky@linuxtv.org>
CC: Harvey Harrison <harvey.harrison@gmail.com>,
       "v4l-dvb-maintainer@linuxtv.org" <v4l-dvb-maintainer@linuxtv.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [v4l-dvb-maintainer] [PATCH] media: replace remaining	__FUNCTION__
 occurences
References: <1204588990.22933.28.camel@brick> <37219a840803031928l79395c78ka64192f4a9f61744@mail.gmail.com>
In-Reply-To: <37219a840803031928l79395c78ka64192f4a9f61744@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Krufky wrote:
> On Mon, Mar 3, 2008 at 7:03 PM, Harvey Harrison
> <harvey.harrison@gmail.com> wrote:
>> __FUNCTION__ is gcc-specific, use __func__
>>
>>  Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
>>   162 files changed, 892 insertions(+), 892 deletions(-)
> 
> 
> If we apply this, can it be broken down into several smaller patches?
> I am in the midst of a large overhaul of the tuning subsystem, and if
> this all gets applied at once, it will wreck havoc on my pending
> changesets.

Please make sure your changes don't conflict with the multiproto tree 
changes.

Regards,
Manu
