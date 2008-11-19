Return-Path: <linux-kernel-owner+w=401wt.eu-S1753456AbYKSNi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456AbYKSNi1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 08:38:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752962AbYKSNiS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 08:38:18 -0500
Received: from an-out-0708.google.com ([209.85.132.250]:13983 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948AbYKSNiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 08:38:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=eVmPZkXNHSy2/+qka7tzPyj73FmYXD1jQkYSCCu3CLf/Iz1j2I1Z9IYHSuMfcdFuap
         j6vPX1izXmP0psPpIjeMUund/OBoo2bkkcvdObBI5soJBFVwoEop3WX3FKGi6i+1jnuh
         P0UYf7LNoTqSf/EqIJ6TJyDg9hBo4X9jJ3RbI=
Message-ID: <8bd0f97a0811190538k21e64ce5gf466400d798b643b@mail.gmail.com>
Date: Wed, 19 Nov 2008 08:38:15 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] genrtc: disable genrtc on Blackfin systems
Cc: "Bryan Wu" <cooloney@kernel.org>, a.zummo@towertech.it,
       rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
In-Reply-To: <20081118222633.2cf8e231.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1226991615-30268-1-git-send-email-cooloney@kernel.org>
	 <20081118222633.2cf8e231.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2008 at 01:26, Andrew Morton wrote:
> On Tue, 18 Nov 2008 15:00:15 +0800 Bryan Wu wrote:
>
>> From: Mike Frysinger <vapier.adi@gmail.com>
>>
>> Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
>> Signed-off-by: Bryan Wu <cooloney@kernel.org>
>
> What is the reason for this change?

if it doesnt work on a platform, then it shouldnt be available.  the
arch list kind of implies that this is like x86 specific anyways ...
-mike
