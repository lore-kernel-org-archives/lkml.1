Return-Path: <linux-kernel-owner+w=401wt.eu-S1752903AbYLHW4y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903AbYLHW4y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 17:56:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752885AbYLHW4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 17:56:37 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:47688 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855AbYLHW4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 17:56:36 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
References: <200812090832.20403.rusty@rustcorp.com.au>
Date: Mon, 08 Dec 2008 14:52:39 -0800
In-Reply-To: <200812090832.20403.rusty@rustcorp.com.au> (Rusty Russell's
	message of "Tue, 9 Dec 2008 08:32:14 +1030")
Message-ID: <m14p1ep9e0.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org, gregkh@suse.de
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Rusty Russell <rusty@rustcorp.com.au>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH] Make Documentation/kobject.txt a little more coherent.
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell <rusty@rustcorp.com.au> writes:

> While reading Documentation/kobject.txt:
>
>   Note kobject_rename does perform any locking or have a solid notion of
>   what names are valid so the provide must provide their own sanity checking
>   and serialization.
>
> I expect better: You never see me hard with time word making sentence
> coherent stuff.  Ever.
>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

Yes.  That does sound better.


> diff --git a/Documentation/kobject.txt b/Documentation/kobject.txt
> --- a/Documentation/kobject.txt
> +++ b/Documentation/kobject.txt
> @@ -118,8 +118,8 @@ the name of the kobject, call kobject_re
>  
>      int kobject_rename(struct kobject *kobj, const char *new_name);
>  
> -Note kobject_rename does perform any locking or have a solid notion of
> -what names are valid so the provide must provide their own sanity checking
> +kobject_rename does not perform any locking or have a solid notion of
> +what names are valid so the caller must provide their own sanity checking
>  and serialization.
>  
>  There is a function called kobject_set_name() but that is legacy cruft and
