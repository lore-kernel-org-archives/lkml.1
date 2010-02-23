Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752230Ab0BWH6R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 02:58:17 -0500
Received: from adelie.canonical.com ([91.189.90.139]:42347 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab0BWH6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 02:58:15 -0500
Message-ID: <4B838A92.5070102@canonical.com>
Date: Mon, 22 Feb 2010 23:58:10 -0800
From: John Johansen <john.johansen@canonical.com>
Organization: Canonical
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: john.johansen@canonical.com, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH 11/12] AppArmor hooks to interface with the LSM, module
 parameters and initialization.
References: <1266572188-26529-1-git-send-email-john.johansen@canonical.com> <1266572188-26529-12-git-send-email-john.johansen@canonical.com> <20100222221412.GA22194@us.ibm.com>
In-Reply-To: <20100222221412.GA22194@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge E. Hallyn wrote:
> Quoting john.johansen@canonical.com (john.johansen@canonical.com):
>> From: John Johansen <john.johansen@canonical.com>
>>
>> Signed-off-by: John Johansen <john.johansen@canonical.com>
>> ---

<< snip >>

>> + */
>> +static int apparmor_cred_alloc_blank(struct cred *cred, gfp_t gfp)
>> +{
>> +	/* freed by apparmor_cred_free */
>> +	struct aa_task_cxt *cxt = aa_alloc_task_context(gfp);
>> +	if (cxt)
>> +		return -ENOMEM;
> 
> if (!cxt)?  :)
> 
yikes, how the????!!!!  Color me embarressed, I don't know how that
slipped in????

thanks
john
