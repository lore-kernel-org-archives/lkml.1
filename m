Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932371Ab0BCEMX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 23:12:23 -0500
Received: from mail-yw0-f198.google.com ([209.85.211.198]:54760 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757192Ab0BCEMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 23:12:22 -0500
Message-ID: <4B68F791.3040006@billgatliff.com>
Date: Tue, 02 Feb 2010 22:12:01 -0600
From: Bill Gatliff <bgat@billgatliff.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PWM PATCH 1/5] API to consolidate PWM devices behind a common
 user and kernel interface
References: <cover.1265094517.git.bgat@billgatliff.com> <c5873aa7c5d20254a9e54fc1ff179345b77c16b5.1265094517.git.bgat@billgatliff.com> <BD79186B4FD85F4B8E60E381CAEE1909020E99E1@mi8nycmail19.Mi8.com>
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE1909020E99E1@mi8nycmail19.Mi8.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H Hartley Sweeten wrote:
>> +	for (wchan = 0; wchan < pwm->nchan; wchan++) {
>> +		if (pwm->channels[wchan].flags & FLAG_REQUESTED) {
>>     
>
> Shouldn't this be:
>
> 	& BIT(FLAG_REQUESTED)
>
>   

Yes.  I've fixed that one several times now!  I think I need to review
my git-fu, especially rebasing.

> Nitpick... Can you move the #ifndef/#define to after the comment?
>   

I did that in all the others, I guess I missed this one...


b.g.

-- 
Bill Gatliff
bgat@billgatliff.com


