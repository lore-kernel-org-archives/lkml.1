Return-Path: <linux-kernel-owner+w=401wt.eu-S1764184AbXFEKeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764184AbXFEKeo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 06:34:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763601AbXFEKeg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 06:34:36 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:35400 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763457AbXFEKef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 06:34:35 -0400
Message-ID: <46653C37.7040303@de.ibm.com>
Date: Tue, 05 Jun 2007 12:34:31 +0200
From: Carsten Otte <cotte@de.ibm.com>
Reply-To: carsteno@de.ibm.com
Organization: =?UTF-8?B?SUJNIERldXRzY2hsYW5kIEVudHdpY2tsdW5nIEdtYkgsVm9ycw==?=
 =?UTF-8?B?aXR6ZW5kZXIgZGVzIEF1ZnNpY2h0c3JhdHM6IEpvaGFubiBXZWloZW4sR2VzY2g=?=
 =?UTF-8?B?w6RmdHNmw7xocnVuZzogSGVyYmVydCBLaXJjaGVyLFNpdHogZGVyIEdlc2VsbHM=?=
 =?UTF-8?B?Y2hhZnQ6IELDtmJsaW5nZW4sUmVnaXN0ZXJnZXJpY2h0OiBBbXRzZ2VyaWNodCA=?=
 =?UTF-8?B?U3R1dHRnYXJ0LCBIUkIgMjQzMjk0?=
User-Agent: Mozilla-Thunderbird 2.0.0.0 (X11/20070521)
MIME-Version: 1.0
To: Vasily Averin <vvs@sw.ru>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, devel@openvz.org,
       linux-ext4@vger.kernel.org, Stephen Tweedie <sct@redhat.com>,
       adilger@clusterfs.com
Subject: Re: [PATCH] [RESEND] ext[34] orphan list check on destroy_inode
References: <466538C9.8080104@sw.ru>
In-Reply-To: <466538C9.8080104@sw.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Vasily Averin wrote:
> Customers claims to ext3-related errors, investigation showed that ext3 orphan
> list has been corrupted and have the reference to non-ext3 inode. The following
> debug helps to understand the reasons of this issue.
This looks like it might be related to the -as far as I recall- 
unfixed issue we've noticed some time ago: 
http://osdir.com/ml/file-systems/2004-02/msg00033.html

I have'nt heard any reports  of a reproduction on modern kernels on 
390 lately, our issue seems to have disappeared.

so long,
Carsten
