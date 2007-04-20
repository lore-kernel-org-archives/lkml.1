Return-Path: <linux-kernel-owner+w=401wt.eu-S1752100AbXDTElW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100AbXDTElW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 00:41:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751033AbXDTElW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 00:41:22 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:54712 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100AbXDTElV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 00:41:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Luy6CvCRHYr+gn4L/rkGOj90ouVwU6srgLM7oUfF2Xwm7tFZntE6w1fYUoGfegaZ4v1jJLFVQfV8dvfBOIC2b3Dap6AumKKl0hFZVqYkmbZVJ+8KIRP3+9anOANUMKUsONrmLUjvnv6+YNztpupCdXDeuapNN8VDnv3Uap2je4s=
Message-ID: <4628446B.9070303@gmail.com>
Date: Fri, 20 Apr 2007 13:41:15 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] libata: add Samsung HD401LJ to the NCQ blacklist
References: <20070418061541.GA11293@roonstrasse.net> <4625BA1A.9030808@gmail.com> <20070418074859.GA21494@roonstrasse.net> <4625CF43.5010704@gmail.com> <20070418120805.GA16989@roonstrasse.net>
In-Reply-To: <20070418120805.GA16989@roonstrasse.net>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Max Kellermann wrote:
> On 2007/04/18 09:56, Tejun Heo <htejun@gmail.com> wrote:
>> It's more likely your chipset just has busted MSI support.  Please
>> post the result of 'lspci -tv' and 'lspci -nn'.
> 
> See attachments.  I found the "nomsi" workaround in a forum, and
> didn't bother to investigate the real cause yet.

Just to be sure, can you post dmesg of boot without 'pci=nomsi'?  If you
root fs is on SATA, you'll probably have to use serial or netconsole to
capture the log.  I wanna be sure that it really is a busted MSI before
submitting patch to disable MSI on the particular chipset.

Thanks.

-- 
tejun
