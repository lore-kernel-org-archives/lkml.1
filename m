Return-Path: <linux-kernel-owner+w=401wt.eu-S934485AbZLPCAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934485AbZLPCAw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 21:00:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934469AbZLPCAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 21:00:50 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:50942 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S934464AbZLPCAt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 21:00:49 -0500
Message-ID: <4B283F40.5080706@cn.fujitsu.com>
Date: Wed, 16 Dec 2009 10:00:32 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill@shutemov.name>
CC: containers@lists.linux-foundation.org, linux-mm@kvack.org,
       Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, Dan Malek <dan@embeddedalley.com>,
       Vladislav Buzov <vbuzov@embeddedalley.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v2 1/4] cgroup: implement eventfd-based generic API
 for notifications
References: <cover.1260571675.git.kirill@shutemov.name> <ca59c422b495907678915db636f70a8d029cbf3a.1260571675.git.kirill@shutemov.name> <4B283B7F.2050403@cn.fujitsu.com>
In-Reply-To: <4B283B7F.2050403@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> +/*
>> + * Check if a file is a control file
>> + */
>> +static inline struct cftype *__file_cft(struct file *file)
>> +{
>> +	if (file->f_dentry->d_inode->i_fop != &cgroup_file_operations)
>> +		return ERR_PTR(-EINVAL);
> 
> I don't think this check is needed.
> 

Sorry, please ignore this comment
