Return-Path: <linux-kernel-owner+w=401wt.eu-S1755406AbZKVQgO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406AbZKVQgO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 11:36:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755275AbZKVQgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 11:36:13 -0500
Received: from mail-gx0-f226.google.com ([209.85.217.226]:58361 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755201AbZKVQgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 11:36:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=VmfxeZOJV7TyLA6LdDJdCrN1KL6U7HHB8+QdOc9sSnxb5JUbbmbHSoMCqPfh4uG0Dh
         ZbHJUGcqF+djtyRJqdUaFZEjc3eFDvHpOzTaTvuIOiBCXq6x0qMqPKXKdUQYt/9sSq+K
         CAAN3DwSZMAfLJEUaYSY5+MCUMyi+l7/EvArI=
Date: Mon, 23 Nov 2009 00:37:00 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: "Helight.Xu" <helight.xu@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: =?utf-8?B?5aaC5L2V6YCa6L+HZmTmib7liLA=?=
	=?utf-8?B?5omT5byA5paH5Lu255qE6Lev5b6E5Y+K5ZCN56ew?=
Message-ID: <20091122163700.GC3476@hack>
References: <4B06384C.2080703@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4B06384C.2080703@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 20, 2009 at 02:33:48PM +0800, Helight.Xu wrote:
> 在用户程序中打开文件进行编辑，那在内核中如何能通过open后的fd
> 来找到相应打开文件的路径及其名字呢？
>

问题是你为什么要在内核中做呢？在用户空间完全可以完成：

 % readlink /proc/<PID>/fd/X


-- 
Live like a child, think like the god.
 
