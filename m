Return-Path: <linux-kernel-owner+w=401wt.eu-S1752429AbZL2PBL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752429AbZL2PBL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 10:01:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752383AbZL2PBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 10:01:10 -0500
Received: from mail-gx0-f211.google.com ([209.85.217.211]:59698 "EHLO
	mail-gx0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190AbZL2PBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 10:01:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=wGBVvx9DFta7ZzL5VrE2/iIuLqbaKAwZ+3tTIOgrFHgO8kzC6lA42LJZFjAFqHGFq0
         FH1EgV7sFmCBoi3HAngc+mAHykfqFHvYFWrmG5QTGPvle0Vk6Ah83RtCWhRPTsGEBjdK
         mEOT6y8WQ2g2BrOGMbP9ellp2LFtclUQlfzyw=
Date: Tue, 29 Dec 2009 23:02:35 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: hooanon05@yahoo.co.jp
Cc: viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: Q. d_alloc() in pipe(2)
Message-ID: <20091229150235.GA2927@hack>
References: <20021.1262066120@jrobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20021.1262066120@jrobl>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 29, 2009 at 02:55:20PM +0900, hooanon05@yahoo.co.jp wrote:
>
>In pipe(2), create_write_pipe() creates a dentry by
>	struct qstr name = { .name = "" };
>	d_alloc(root, &name);
>
>But d_alloc() refers name->len which is uninitialized.

Well, it is initialized to 0. :)

>Isn't it better to replace d_alloc() by d_alloc_name(root, "")?
>

Maybe not, they totally equal in this case, IMO.

-- 
Live like a child, think like the god.
 
