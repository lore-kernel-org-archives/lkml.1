Return-Path: <linux-kernel-owner+w=401wt.eu-S1755223AbYAZXtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223AbYAZXtR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 18:49:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753114AbYAZXtF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 18:49:05 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:49809 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948AbYAZXtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 18:49:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:organization:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=MGctZj97e7HIMOQvv3yR3RWC68X82tVASF1LYEn0LUFYQakiNnUpRVmJk1pB7X41jtC2yvI8+nVI5cRNm2jKH8k093/YkFUYB6pnsUX+X+6dVIUZsWKdJBxT2N28T34e1CWxLbJ1aEURk+qEI3l3FmqhZzDWOd73YpRptGCWufg=
Message-ID: <479BC6E5.5000409@gmail.com>
Date: Sun, 27 Jan 2008 02:48:53 +0300
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Organization: DmVo Home
User-Agent: Thunderbird 1.5.0.14pre (X11/20071022)
MIME-Version: 1.0
To: Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
CC: trivial@kernel.org, linux-fsdevel@vger.kernel.org, apw@shadowen.org,
       rdunlap@xenotime.net, jschopp@austin.ibm.com,
       Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 8/9] bfs: remove multiple assignments
References: <1201296027-6900-1-git-send-email-dmitri.vorobiev@gmail.com> <1201296027-6900-9-git-send-email-dmitri.vorobiev@gmail.com> <Pine.LNX.4.61.0801261833270.1966@ginsburg.homenet>
In-Reply-To: <Pine.LNX.4.61.0801261833270.1966@ginsburg.homenet>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tigran Aivazian wrote:
> On Sat, 26 Jan 2008, Dmitri Vorobiev wrote:
>> -    inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME_SEC;
>> +    inode->i_mtime = CURRENT_TIME_SEC;
>> +    inode->i_atime = CURRENT_TIME_SEC;
>> +    inode->i_ctime = CURRENT_TIME_SEC;
> 
> multiple assignments like "x = y = z = value;" can potentially
> (depending on the compiler and arch) be faster than "x = value; y =
> value; z=value;"
> 
> I am surprized that this script complains about them as it is a
> perfectly valid thing to do in C.

I think it seems wise to ask the maintainers of checkpatch.pl to
comment on that. I'm Cc:ing them now.

Thanks,

Dmitri

