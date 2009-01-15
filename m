Return-Path: <linux-kernel-owner+w=401wt.eu-S1763229AbZAOTPB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763229AbZAOTPB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 14:15:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755104AbZAOTOx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 14:14:53 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:59163 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754053AbZAOTOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 14:14:52 -0500
Message-ID: <496F8AED.3020604@oracle.com>
Date: Thu, 15 Jan 2009 11:13:49 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@linux-foundation.org>, swhiteho@redhat.com,
       cluster-devel@redhat.com
Subject: Re: mmotm 2009-01-14-20-31 uploaded (gfs2)
References: <200901150432.n0F4WI66023742@imap1.linux-foundation.org>
In-Reply-To: <200901150432.n0F4WI66023742@imap1.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt704.oracle.com [141.146.40.82]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A09020B.496F8AF3.01C5:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2009-01-14-20-31 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> and will soon be available at
> 
>    git://git.zen-sources.org/zen/mmotm.git


when CONFIG_FILE_LOCKING=n:

mmotm-2009-0114-2031/fs/gfs2/ops_file.c:746: error: 'generic_setlease' undeclared here (not in a function)


since generic_setlease() is a macro/define in that case.

-- 
~Randy
