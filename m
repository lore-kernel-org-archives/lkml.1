Return-Path: <linux-kernel-owner+w=401wt.eu-S1767567AbXCIWYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767567AbXCIWYV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 17:24:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767568AbXCIWYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 17:24:21 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:42282 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767567AbXCIWYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 17:24:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=s7YP7lVS6oGTuEaWNIeWQVUJYA0vLGZU7NuB9EP+INvchkRJhCrE9rUJNByJf68sgWN9B+WP71xYgPO3dhrWcnH5ArTQFEmTCZDj4+Hh2+OFx0F0uZhKkss8OACeVJNlGh778TbSLpYClbuB/hZ2sC8l3GMvslT4G94MxXxqXfY=
Message-ID: <4ae3c140703091424i25a0a3fcm6ba9d7bf348d04b6@mail.gmail.com>
Date: Fri, 9 Mar 2007 17:24:18 -0500
From: "Xin Zhao" <uszhaoxin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: question regarding the Linux block device cache
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am working on a file system that allow multiple files to share data
blocks. That is, a data block can be shared by two or more files. Now
my question is: suppose file A and B share the same data block D. Now
a process open file A and read block D, then this process closes file
A. If another process open file B and read block D right after the
first process closes A, is the data of block D read from some cache or
has to be loaded from disk again? I think this has to do with the
Linux block device buffer cache. But I am not quite familiar with this
part.

Can someone help me or direct me to the right place to find the answer?

Thanks in advance!

-x
