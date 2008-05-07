Return-Path: <linux-kernel-owner+w=401wt.eu-S1761156AbYEGPHL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761156AbYEGPHL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 11:07:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757019AbYEGPGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 11:06:54 -0400
Received: from ti-out-0910.google.com ([209.85.142.185]:5239 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754759AbYEGPGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 11:06:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ezPss1VD97rOOky6gD9WHZ1mpYosdKnSi6z38a/PhbvtmtdCdb7wNNO2L03yFxM5AmW5UuvmibtzR5kWcSDe6jr4mhiumRBmvLLyP1AjnTLauVFHElZvao0EfhTkMIjqqTXjc8yn8mM+lsgQ8dBwkT1aDSDQkRGMhf1hv+arhkk=
Message-ID: <91b13c310805070806p23517840udee3aca65a33bc81@mail.gmail.com>
Date: Wed, 7 May 2008 23:06:49 +0800
From: "rae l" <crquan@gmail.com>
To: "Matthew Wilcox" <matthew@wil.cx>
Subject: Re: It's time to hack on dentry_stat?
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080507145116.GV19219@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <91b13c310805070726k7eb1384ex7d557b5dca4b567@mail.gmail.com>
	 <20080507145116.GV19219@parisc-linux.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 7, 2008 at 10:51 PM, Matthew Wilcox <matthew@wil.cx> wrote:
>  You have to not break:
>
>  $ cat /proc/sys/fs/dentry-state
>  122104  115846  45      0       0       0
But why? for some applicatioins?

The struct dentry_stat can be modified to have only two useful fields,
and let the other four printed with 0,
I have greped age_limit, that's also not used anymore, why we should
let it keep 45? Or Is there some historical reason?

Or just consider /proc/sys/fs/dentry-state as a binary application interface?
