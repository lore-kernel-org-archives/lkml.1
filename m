Return-Path: <linux-kernel-owner+w=401wt.eu-S933045AbXDFXQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933045AbXDFXQp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 19:16:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933114AbXDFXQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 19:16:45 -0400
Received: from terminus.zytor.com ([192.83.249.54]:37368 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933045AbXDFXQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 19:16:43 -0400
Message-ID: <4616D4D4.6020405@zytor.com>
Date: Fri, 06 Apr 2007 16:16:36 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
       util-linux-ng@vger.kernel.org, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 0/8] unprivileged mount syscall
References: <20070404183012.429274832@szeredi.hu> <20070406160238.f3178189.akpm@linux-foundation.org>
In-Reply-To: <20070406160238.f3178189.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>
>> - users can use bind mounts without having to pre-configure them in
>>   /etc/fstab
>>

This is by far the biggest concern I see.  I think the security 
implication of allowing anyone to do bind mounts are poorly understood.

	-hpa
