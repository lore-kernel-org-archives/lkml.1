Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660Ab0BHLAR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 06:00:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21389 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752291Ab0BHLAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 06:00:13 -0500
Message-ID: <4B6FEE80.5030202@redhat.com>
Date: Mon, 08 Feb 2010 18:59:12 +0800
From: Xiaotian Feng <dfeng@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: James Morris <jmorris@namei.org>
CC: eparis@parisplace.org, sds@tycho.nsa.gov, paul.moore@hp.com,
       serue@us.ibm.com, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] selinux: fix memory leak in sel_make_bools
References: <1250151976-19399-1-git-send-email-dfeng@redhat.com> <1250215360-20871-1-git-send-email-dfeng@redhat.com> <alpine.LRH.2.00.0908141606290.12770@tundra.namei.org>
In-Reply-To: <alpine.LRH.2.00.0908141606290.12770@tundra.namei.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2009 02:06 PM, James Morris wrote:
> On Fri, 14 Aug 2009, Xiaotian Feng wrote:
>
>> In sel_make_bools, kernel allocates memory for bool_pending_names[i]
>> with security_get_bools. So if we just free bool_pending_names, those
>> memories for bool_pending_names[i] will be leaked.
>
> Thanks, applied and pushed to Linus.
This patch is missing or dropped? I'm not seeing this patch until 
2.6.33-rc7, thanks.

