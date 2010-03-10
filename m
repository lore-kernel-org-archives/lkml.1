Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932071Ab0CJFla (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 00:41:30 -0500
Received: from smtp-out.google.com ([216.239.33.17]:34162 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689Ab0CJFl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 00:41:28 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=WHo9tb+VWIY5uSwLcAhzzM4TyCb0IpDhCmONWvSKr1960fGacIoE83wJDkHyIq+H/
	y3V/lCwGQd3hSWzPo+X/A==
MIME-Version: 1.0
In-Reply-To: <4B96E8CC.9080803@cn.fujitsu.com>
References: <e98e18941003031519v14d4f79cg33da5c3cf1f5ac03@mail.gmail.com>
	 <4B8F62B7.3080401@cn.fujitsu.com> <20100304152400.GB18786@redhat.com>
	 <4B906BB6.3080104@cn.fujitsu.com> <20100305141300.GA3296@redhat.com>
	 <e98e18941003081139v7a84a979mf8fa49f4744060ea@mail.gmail.com>
	 <20100308230905.GB3614@redhat.com> <4B95A9C6.9060504@cn.fujitsu.com>
	 <20100309190340.GD8663@redhat.com> <4B96E8CC.9080803@cn.fujitsu.com>
Date: Tue, 9 Mar 2010 21:41:23 -0800
Message-ID: <1786ab031003092141j48599b09vc80741f35a34d71c@mail.gmail.com>
Subject: Re: [PATCH 1/2 V3] io-controller: Add a new interface "weight_device" 
	for IO-Controller
From: Chad Talbott <ctalbott@google.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Nauman Rafique <nauman@google.com>,
       jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       Li Zefan <lizf@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 9, 2010 at 4:33 PM, Gui Jianfeng <guijianfeng@cn.fujitsu.com> wrote:
> Vivek Goyal wrote:
>> On Tue, Mar 09, 2010 at 09:52:06AM +0800, Gui Jianfeng wrote:
>> I am not very sure but device name/path interface might turn out to be
>> more intutive.
>
> I don't think using an inode path name as interface is a good idea. Because, one
> can create new file to point to the same device. Also, pathname could be removed
> or renamed by user.
> So, i think device number is a better choice.

Sorry to butt in, but I don't think anyone is suggesting trying to
remember names from device nodes.  I think the idea is to use the
names derived from the subsystem - such as 'sda' which is reflected in
/sys and dmesg.

Chad
