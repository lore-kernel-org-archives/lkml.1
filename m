Return-Path: <linux-kernel-owner+w=401wt.eu-S1765762AbYAaHs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765762AbYAaHs4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 02:48:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765350AbYAaHsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 02:48:41 -0500
Received: from swsoft-msk-nat.sw.ru ([195.214.232.10]:58271 "EHLO iris.sw.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1765206AbYAaHsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 02:48:40 -0500
Message-ID: <47A17D50.4000409@sw.ru>
Date: Thu, 31 Jan 2008 10:48:32 +0300
From: "Denis V. Lunev" <den@sw.ru>
User-Agent: Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: "Denis V. Lunev" <den@openvz.org>, trond.myklebust@fys.uio.no,
       linux-kernel@vger.kernel.org, xemul@openvz.org, devel@openvz.org
Subject: Re: [PATCH] [NFS]: Lock daemon start/stop rework.
References: <1201693294-11460-1-git-send-email-den@openvz.org> <20080131033320.GA15067@infradead.org>
In-Reply-To: <20080131033320.GA15067@infradead.org>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Wed, Jan 30, 2008 at 02:41:34PM +0300, Denis V. Lunev wrote:
>> The pid of the locking daemon can be substituted with a task struct
>> without a problem. Namely, the value if filled in the context of the lockd
>> thread and used in lockd_up/lockd_down.
>>
>> It is possible to save task struct instead and use it to kill the process.
>> The safety of this operation is guaranteed by the RCU, i.e. task can't
>> disappear without passing a quiscent state.
> 
> We have a patch series pending on the nfs list that does this plus a lot
> more in the area.
> 
> 
where can I have to look them? :)
