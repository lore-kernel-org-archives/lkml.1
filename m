Return-Path: <linux-kernel-owner+w=401wt.eu-S1755960AbYAZKRp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755960AbYAZKRp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 05:17:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753106AbYAZKRf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 05:17:35 -0500
Received: from qb-out-0506.google.com ([72.14.204.227]:52964 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410AbYAZKRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 05:17:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent;
        b=XX5+3P+dXrTmXESxiLHpv6lK/IKXjPU3ep1AeFjk00BM4h1bDstD08MPlMiTQzm5kRvcaar+J0a/uWerqeDYQIqZMbOEaszA40Im8wfAmIPatKjJWQpY43nPNXnC71CBCDHv1ivd6WJR1djegpXNEooNujl2G3IMxdKMVCmz70E=
Date: Sat, 26 Jan 2008 18:15:23 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: WANG Cong <xiyou.wangcong@gmail.com>, Greg KH <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Subject: Re: [Patch] Shut up warnings from files under drivers/
Message-ID: <20080126101522.GC20935@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <20080126093007.GB20935@hacking> <20080126095723.GA22285@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080126095723.GA22285@uranus.ravnborg.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 26, 2008 at 10:57:23AM +0100, Sam Ravnborg wrote:
>Hi WANG.
>On Sat, Jan 26, 2008 at 05:30:07PM +0800, WANG Cong wrote:
>> 
>> Fix two kind of defined-but-not-used warnings.
>> 
>> One is due to defination of MODULE_DEVICE_TABLE, the
>> other is due to __devexit_p. The solution is just to
>> add proper directives to protect those usages.
>
>Please include the actual warnings that you fix.
>

Sure.

Such as this one:

drivers/char/applicom.c:68: warning: ‘applicom_pci_tbl’ defined but not used

Others are similar.

