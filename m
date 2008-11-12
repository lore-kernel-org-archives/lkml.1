Return-Path: <linux-kernel-owner+w=401wt.eu-S1755141AbYKLXlc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755141AbYKLXlc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 18:41:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756875AbYKLXhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 18:37:00 -0500
Received: from wf-out-1314.google.com ([209.85.200.169]:1739 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756201AbYKLXg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 18:36:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=nD/R+6cM6Qqr0TD8s9+6AqiTDpJbgsvhbW4fhqezydmV06px+YuDzhGJgpos+lKxkz
         ZQ8cJUlv58unS8xRGfe0+ANrzxp0oCpfO2bm+dH1Di3puir9BJLABw9imeqjSUpKKubk
         qovlxb9lFhoFQvNEUZPQ03RuHqAZx/cK7xeQ8=
Message-ID: <8bd0f97a0811121536r4967b5ddh675a60216c1fb800@mail.gmail.com>
Date: Wed, 12 Nov 2008 18:36:57 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: [PATCH] staging/wlan-ng: kill WLAN_CPU_FAMILY and WLAN_SYSARCH
Cc: "Mike Frysinger" <vapier@gentoo.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20081112224628.GD27479@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1226500540-9667-1-git-send-email-vapier@gentoo.org>
	 <20081112224628.GD27479@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2008 at 17:46, Greg KH wrote:
> On Wed, Nov 12, 2008 at 09:35:40AM -0500, Mike Frysinger wrote:
>> The WLAN_CPU_FAMILY and WLAN_SYSARCH defines are used in all of three places
>> (two of which look pretty suspect), so just kill them off rather than
>> throwing up a pointless #error on processors that are not in the existing
>> list.
>
> Thanks, but this is already cleaned up in my tree with a patch from
> someone else.

where ?  i looked in staging.git and that hasnt been touched in 2 months.
-mike
