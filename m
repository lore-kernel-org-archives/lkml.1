Return-Path: <linux-kernel-owner+w=401wt.eu-S932140AbYBFB1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932140AbYBFB1W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 20:27:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754982AbYBFB1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 20:27:14 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:48234 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753424AbYBFB1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 20:27:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Md5jfQHmuXDQKCpP0y4JYAoyp5Js8qzRsycWrKRulc1QIxaMwPk/iCpWT1Zd0X1yCXdIzIXRa3iCyJqO0VppUZfDgM9iyedpiAcwYbi1FdLWSFVP2ZfpnI4Nu8z8KZoWf7GqyLo7DFCBpm5EerlP1GI5vWierqxExyu8sZSY6Ds=
Message-ID: <75b66ecd0802051727r6e3133dfxc8b263af085abf7@mail.gmail.com>
Date: Tue, 5 Feb 2008 20:27:09 -0500
From: "Lee Revell" <rlrevell@joe-job.com>
To: "Chuck Ebbert" <cebbert@redhat.com>
Subject: Re: New RTC drivers don't provide the sysctl to set max user frequency
Cc: vapier.adi@gmail.com, linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <47A8E90D.4000008@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47A8E90D.4000008@redhat.com>
X-Google-Sender-Auth: 01e3d3c43cb570d5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 5, 2008 5:54 PM, Chuck Ebbert <cebbert@redhat.com> wrote:
> Is every application that uses /proc/sys/dev/rtc/max-user-freq
> supposed to be updated to use the new /sys interface?

IMHO the default should be increased to 1024 - the current default of
64 dates back to the 486 era.  This would eliminate the need for a lot
of apps to touch it at all.

Unprivileged users have lots of other ways to generate more than 1024
interrupts/second anyway.

Lee
