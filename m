Return-Path: <linux-kernel-owner+w=401wt.eu-S1755546AbZAIUMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546AbZAIUMW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 15:12:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752491AbZAIUMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 15:12:05 -0500
Received: from linode.davidb.org ([72.14.176.16]:54481 "EHLO mail.davidb.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753155AbZAIUME (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 15:12:04 -0500
X-Greylist: delayed 2056 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Jan 2009 15:12:03 EST
Date: Fri, 9 Jan 2009 11:37:39 -0800
From: David Brown <lkml@davidb.org>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: Phil Oester <kernel@linuxace.com>, Kay Sievers <kay.sievers@vrfy.org>,
       Phillip Lougher <phillip@lougher.demon.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [GIT PULL] Squashfs pull request for 2.6.29
Message-ID: <20090109193738.GA9827@linode.davidb.org>
References: <E1LKy3v-0003KO-Nx@dylan.lougher.demon.co.uk> <20090108165029.GA10951@infradead.org> <20090108175338.2abbee16.akpm@linux-foundation.org> <4966B24E.1050700@lougher.demon.co.uk> <ac3eb2510901081824g38abc47g4619e80ffaf8f1c5@mail.gmail.com> <20090109023629.GA29520@linuxace.com> <20090109165422.GF24884@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090109165422.GF24884@logfs.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 09, 2009 at 05:54:22PM +0100, Jörn Engel wrote:
>On Thu, 8 January 2009 18:36:29 -0800, Phil Oester wrote:
>> 
>> Agreed...I'm tired of having to pull along a patch to vanilla kernels
>> for squashfs.  Drivers are merged that don't even _work_ these days,
>> so why is there so much concern about merging something which almost
>> all distros use which impacts almost nothing if you don't enable it???
>
>In general, filesystems and ABI changes are special because stupid
>mistakes are eternal.  If some device driver has a bug, you can fix it,
>reboot and be done with it.  Not so with filesystems.

Squashfs is readonly from the kernel.  The images are created with
userspace tools.

David
