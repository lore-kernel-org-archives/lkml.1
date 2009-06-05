Return-Path: <linux-kernel-owner+w=401wt.eu-S1753876AbZFEEEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876AbZFEEEY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 00:04:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750832AbZFEED6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 00:03:58 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:44644 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701AbZFEED5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 00:03:57 -0400
Message-ID: <4A289928.7040508@oracle.com>
Date: Fri, 05 Jun 2009 12:03:52 +0800
From: Tao Ma <tao.ma@oracle.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: /proc/kcore has a unreasonable size(281474974617600) in x86_64 2.6.30-rc8.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt002.oracle.com [141.146.116.11]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4A28992C.00D8:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi list,
       In 2.6.30-rc8, /proc/kcore in x86_64's size is unreasonable large 
to be 281474974617600.
While in a x86 box, it is 931131392 which looks sane.

[root@test8 ~]# ll /proc/kcore
-r-------- 1 root root 281474974617600 Jun  5 11:15 /proc/kcore

[root@ocfs2-test9 ~]$ ll /proc/kcore
-r-------- 1 root root 931131392 Jun  5 11:58 /proc/kcore

I just noticed this when kexec fails in "Can't find kernel text map area 
from kcore".

Is there something wrong?

Regards,
Tao

