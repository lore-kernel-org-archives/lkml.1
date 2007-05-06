Return-Path: <linux-kernel-owner+w=401wt.eu-S933465AbXEFBsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933465AbXEFBsh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 21:48:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934356AbXEFBsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 21:48:37 -0400
Received: from nz-out-0506.google.com ([64.233.162.233]:5102 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933465AbXEFBsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 21:48:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=c+JQzT2OL/93w/eH06DKxDUGFMRBjO3gXpIwxUtSVDyKS1zqQlS/L956bZZsGovU41rbUlOkVDb879tE8aKavJ0QdVzz0hB4hiHSWIKruW1YQENRlWR7ZtQun++2jJZBC7GsKFaG5zHodzgsZ2Gkqf0BvghVB2LrYKAFdtSd8IQ=
Message-ID: <787b0d920705051848u142562a5lb5d581d0e5616cc8@mail.gmail.com>
Date: Sat, 5 May 2007 21:48:35 -0400
From: "Albert Cahalan" <acahalan@gmail.com>
To: mason.b.cabot@intel.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, jra@samba.org, tridge@samba.com
Subject: Re: Ext3 vs NTFS performance
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton writes:
> "Cabot, Mason B" <mason.b.cabot@intel.com> wrote:

>> I've been testing the NAS performance of ext3/Openfiler 2.2 against
>> NTFS/WinXP and have found that NTFS significantly outperforms ext3 for
>> video workloads. The Windows CIFS client will attempt a poor-man's
>> pre-allocation of the file on the server by sending 1-byte writes at
>> 128K-byte strides, breaking block allocation on ext3 and leading to
>> fragmentation and poor performance. This will happen for many
>> applications (including iTunes) as the CIFS client issues these
>> pre-allocates under the application layer.
>
> Oh my gawd, what a stupid hack.  Now we know what the
> MS interoperability lab has been working on.

Stupid or not, this is their protocol. The cifs filesystem
driver needs a patch to do this. Probably that'll help get
better performance when Linux is writing to a Windows server.
