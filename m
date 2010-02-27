Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965643Ab0B0LAO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 06:00:14 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:35445 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965544Ab0B0LAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 06:00:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=YiDLJHQ9dkKk5ev+bOO3wiRINAPqWJ17MCYwLt0iM2QEAAvgrl6NH4VIQUPcS3lv7w
         pZy2TXdCnIGryTjsS59KxpXgsYCioOF5NIZYuSFIzizmgry2S2vW51L2z/1mRG7t//FD
         Tf+8UMMSovgezWU6H6fDty5/8nE/+rmcHJNDE=
MIME-Version: 1.0
In-Reply-To: <4B88F5ED.9040405@aliencamel.com>
References: <4B88F5ED.9040405@aliencamel.com>
Date: Sat, 27 Feb 2010 13:00:07 +0200
Message-ID: <269694c01002270300q3439b927q2ac7b30c57261b0d@mail.gmail.com>
Subject: Re: patch Staging-comedi-fix-coding-style-issues.patch
From: Ameya Palande <2ameya@gmail.com>
To: Stewart Robertson <stewart_r@aliencamel.com>
Cc: Greg KH <gregkh@suse.de>, wfp5p@virginia.edu, linux@dominikbrodowski.net,
       keil@b1-systems.de, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stewart,

On Sat, Feb 27, 2010 at 12:37 PM, Stewart Robertson
<stewart_r@aliencamel.com> wrote:
> I did some research and had a go at fixing the warning
> 'WARNING: printk() should include KERN_ facility level'
> by adding KERN_INFO in front of the quoted text. Please let me know if that
> is the right thing to do and if not,
> what I should do instead.

Yes this is right thing to do "printk(KERN_INFO "");"
You can also do pr_info("");

Cheers,
Ameya.
