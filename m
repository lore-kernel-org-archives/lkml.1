Return-Path: <linux-kernel-owner+w=401wt.eu-S1752349AbZGXOzE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752349AbZGXOzE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 10:55:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751877AbZGXOzD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 10:55:03 -0400
Received: from smtp104.prem.mail.sp1.yahoo.com ([98.136.44.59]:44478 "HELO
	smtp104.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751854AbZGXOzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 10:55:01 -0400
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: 2dSYObYVM1lbJ8Ei4A4PPGbOdqv0eDPHDICryfAjNbw2mb.VOwZh4TKwEniaovNDIJuDCXJfP0g_JTf7Xeu__53PJy0Y3WjATobcxCc1rJn4DpkgY6SZ31Eqy4sn41LNgX.O0kCHk.vEvREqtN83EJR1UpZOhJjYVwIXNCDQ12GT_O3CYwcaomFvNTU.r5VFCOgtUfJk_HqFHdeKLN_QeF.gdqZTlTuK8JDxVXj0Nib_O.SQkyWLanoMib5KCDh2cpGn85tyWo.8RZZltxET9Gk5T9fX4OMoscuC3MnWvqstV48kogoi5bQ0tOeeY3cNTTVhhYFxxEMApGEleLLOeWSt3klZV7Oazdlr6Oo-
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4A69CB26.1070801@schaufler-ca.com>
Date: Fri, 24 Jul 2009 07:54:30 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: "David P. Quigley" <dpquigl@tycho.nsa.gov>
CC: James Morris <jmorris@namei.org>, sds@tycho.nsa.gov,
       Greg KH <greg@kroah.com>, ebiederm@xmission.com,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       selinux@tycho.nsa.gov
Subject: Re: [PATCH] Security/sysfs: Enable security xattrs to be set on sysfs
 files, directories, and symlinks.
References: <1247665721-2619-1-git-send-email-dpquigl@tycho.nsa.gov>	 <1248194067.10726.22.camel@localhost> <1248195700.10726.28.camel@localhost>	 <alpine.LRH.2.00.0907241810490.32272@tundra.namei.org> <1248446041.2421.74.camel@localhost>
In-Reply-To: <1248446041.2421.74.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David P. Quigley wrote:
> On Fri, 2009-07-24 at 18:13 +1000, James Morris wrote:
>   
>> On Tue, 21 Jul 2009, David P. Quigley wrote:
>>
>>     
>>> Looking more closely at the problem I was mistaken. I was concerned with
>>> the dereferenceing of the dentry in the first line of the getxattr
>>> function but it seems that a precondition for us getting that far is
>>> that we will always have a valid dentry at that point. I'd appreciate it
>>> if the people whose code the patch touches can review the patch again
>>> and either NAK with more comments or sign off on it.
>>>       
>> Please repost them with a version number so we know exactly which patches 
>> we're looking at.
>>
>>
>>     
>
> Casey is taking a shot at implementing generic xattr support for in
> memory file systems.I told him I'd wait to see the initial cut of his
> patch before going further with this.
>
>   

Work is under way. I hope to be done in a few days. No big time chunks
available unfortunately.

> Dave
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>   
