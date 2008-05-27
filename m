Return-Path: <linux-kernel-owner+w=401wt.eu-S1760585AbYE0WH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760585AbYE0WH5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 18:07:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760035AbYE0WHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 18:07:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34746 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759997AbYE0WHC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 18:07:02 -0400
Message-ID: <483C85F2.6040103@cs.wisc.edu>
Date: Tue, 27 May 2008 17:06:42 -0500
From: Mike Christie <michaelc@cs.wisc.edu>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: James.Bottomley@HansenPartnership.com,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi/libiscsi.c: return -errno rather than errno
References: <483BBF36.80500@cn.fujitsu.com>
In-Reply-To: <483BBF36.80500@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
> iscsi_prep_scsi_cmd_pdu() returns EIO in a failing path,
> but returns -errno in other paths.
> 

Thanks for the patch. I fixed this in the patches I sent to James for 
2.6.27 already.
