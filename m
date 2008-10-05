Return-Path: <linux-kernel-owner+w=401wt.eu-S1755704AbYJEKCx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755704AbYJEKCx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 06:02:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753781AbYJEKCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 06:02:44 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:64822 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660AbYJEKCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 06:02:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:references
         :in-reply-to:content-type:content-transfer-encoding:from:sender;
        b=SOaGR8EZ+vyl5vU3VTL0nHgX4qOTBGsHC9D8Cqtl++GRZIloAImYOIbdWFsrcS8qYH
         C1uvtB3+Q3vJDzHBQr9Hvy76J4gydzLhkYhLErOQAxPyK6lVfVpTfWTKSACFmEQnPWHL
         2VgNXdha9ov+qm1j91fIzrrAjcSqlCcwU2aRg=
Message-ID: <48E890B9.6050307@gmail.com>
Date: Sun, 05 Oct 2008 12:02:33 +0200
User-Agent: Thunderbird 3.0a1 (X11/2008050714)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org, lists@ku-gbr.de, bhalevy.lists@gmail.com
Subject: Re: SATA Cold Boot problems on >2.6.25 with NV
References: <fa.CVrJhjm3R8sjl5Z+EEIzYm7QtW0@ifi.uio.no> <48B80B40.5060002@shaw.ca> <48B80D33.5050806@gmail.com> <20080829212146.GA4321@anita> <48B90F7F.8040308@kernel.org> <48D89C85.2080104@panasas.com> <20080924084846.GA2094@anita> <48DA0A2C.8010008@kernel.org>
In-Reply-To: <48DA0A2C.8010008@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Benny Halevy <bhalevy@panasas.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sep. 24, 2008, 12:36 +0300, Tejun Heo <tj@kernel.org> wrote:
> Please apply the attached patch and post the resulting log.  Please
> don't forget to turn on KALLSYMS.
> 
> Thanks.
> 

With commit 4c1eb90a0908c0c60db2169dce08fb672e7582f1 (v2.6.27-rc8),
I see no spurious EH complete events as I saw with 2.6.27-rc <= 7.

Thanks,

Benny
