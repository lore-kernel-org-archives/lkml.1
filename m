Return-Path: <linux-kernel-owner+w=401wt.eu-S1759991AbZJJMUI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759991AbZJJMUI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 08:20:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759098AbZJJMUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 08:20:06 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:59904 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759053AbZJJMUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 08:20:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=uzf7Tqt9yOsfDyxeuhUOUTs8bqfLBtxx7Pi8AJdDoso4ZSk1YuJvsiLVl50Uk5DDxK
         FrLBPO3ocpviZU2hzl5DhF/9MjZJlW03vS/5EM/neevX6PYTVl9k9kNM97hF/eBM2iFU
         Taf/jrxdkmj68dWxOOdCKMHv1aGEGhGmeC5Pk=
Message-ID: <4AD07BCD.1000902@gmail.com>
Date: Sat, 10 Oct 2009 14:19:25 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-2.7 Thunderbird/3.0b4
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: rjw@sisk.pl, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] PM / Hibernate: swap, use KERN_CONT
References: <1255176024-12420-1-git-send-email-jirislaby@gmail.com> <20091010121504.GB1943@ucw.cz>
In-Reply-To: <20091010121504.GB1943@ucw.cz>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2009 02:15 PM, Pavel Machek wrote:
> On Sat 2009-10-10 14:00:24, Jiri Slaby wrote:
>> Use KERN_CONT in save_image for printks. So that anybody won't
>> try to add a loglevel.
> 
> Someone has a big, pending patch to switch to pr_*. Should we take
> that instead?

I have no problem with that at all.
