Return-Path: <linux-kernel-owner+w=401wt.eu-S1753452AbZKOS7J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452AbZKOS7J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 13:59:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752417AbZKOS7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 13:59:09 -0500
Received: from casper.infradead.org ([85.118.1.10]:48988 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171AbZKOS7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 13:59:08 -0500
Date: Sun, 15 Nov 2009 11:00:43 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>,
       Al Viro <viro@ZenIV.linux.org.uk>, mingo@elte.hu,
       Frederic Weisbecker <fweisbec@gmail.com>, auke-jan.h.kok@intel.com
Subject: Re: [PATCH] vfs: Add a trace point in the mark_inode_dirty function
Message-ID: <20091115110043.6cafc221@infradead.org>
In-Reply-To: <4AFA2293.5080803@cn.fujitsu.com>
References: <20091025225342.007138f5@infradead.org>
	<4AFA2293.5080803@cn.fujitsu.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Nov 2009 10:33:55 +0800
Li Zefan <lizf@cn.fujitsu.com> wrote:
> 
> This will leave __entry->comm, __entry->file and __entry->dev
> uninitialized in the "else" case..

I would expect the struct to be zeroed before.... is it?
(the TP_ stuff is so obscure I find it hard to figure out where it ends
up)


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
