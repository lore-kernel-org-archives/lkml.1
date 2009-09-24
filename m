Return-Path: <linux-kernel-owner+w=401wt.eu-S1752824AbZIXJTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824AbZIXJTv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 05:19:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752656AbZIXJTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 05:19:50 -0400
Received: from outbound.icp-qv1-irony-out4.iinet.net.au ([203.59.1.150]:17655
	"EHLO outbound.icp-qv1-irony-out4.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752434AbZIXJTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 05:19:49 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEABfXukrLO0En/2dsb2JhbADWFYQbBYFYZQ
X-IronPort-AV: E=Sophos;i="4.44,444,1249228800"; 
   d="scan'208";a="468155341"
Message-ID: <4ABB39B1.4000905@themaw.net>
Date: Thu, 24 Sep 2009 17:19:45 +0800
From: Ian Kent <raven@themaw.net>
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: Sage Weil <sage@newdream.net>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@infradead.org>,
       Andreas Dilger <adilger@sun.com>, Yehuda Saheh <yehuda@newdream.net>,
       Jim Garlick <garlick@llnl.gov>
Subject: Re: [RFC PATCH 00/11] autofs4 - update autofs4 to deal with VFS locking
 change
References: <20090924082036.22151.85151.stgit@zeus.themaw.net>
In-Reply-To: <20090924082036.22151.85151.stgit@zeus.themaw.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Kent wrote:
> A change to the VFS path walk locking is needed to resolve an issue
> identified by Sage Weil. This locking change requires significant
> changes to the autofs4 module to allow it to callback to userspace
> without introducing a deadlock.

Oops, meant to say this series is against the current Linus tree and not
  the current mm tree. However, I don't expect there will be differences
in the autofs4 patches.

Ian

