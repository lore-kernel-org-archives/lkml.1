Return-Path: <linux-kernel-owner+w=401wt.eu-S1032541AbXEHWhK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032541AbXEHWhK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 18:37:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1032538AbXEHWhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 18:37:05 -0400
Received: from gw.goop.org ([64.81.55.164]:53768 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1032536AbXEHWhC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 18:37:02 -0400
Message-ID: <4640FB8B.5080406@goop.org>
Date: Tue, 08 May 2007 15:36:59 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
CC: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>
Subject: Re: [patch 2/4] add argv_split()
References: <20070508205129.064843364@goop.org> <20070508205517.142888645@goop.org> <Pine.LNX.4.61.0705090029590.2342@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0705090029590.2342@yvahk01.tjqt.qr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On May 8 2007 13:51, Jeremy Fitzhardinge wrote:
>   
>> +
>> +static const char *skip_sep(const char *cp)
>>     
>
> These are so simple they could use an 'inline' tag.
>   

I'm sure the compiler can work that out for itself.

>> +#ifdef TEST
>>     
>
> But not in the end result.
>   

?

>> +int main() {
>> +	const char *testvec[] = {
>>     
>
> Suggesting static const char *const testvec[].
>   

I guess, but it doesn't matter much.

    J
