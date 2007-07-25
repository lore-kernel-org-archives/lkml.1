Return-Path: <linux-kernel-owner+w=401wt.eu-S932859AbXGYQuy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932859AbXGYQuy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 12:50:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759226AbXGYQur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 12:50:47 -0400
Received: from main.gmane.org ([80.91.229.2]:59066 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755682AbXGYQuq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 12:50:46 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Ed Swierk <eswierk@arastra.com>
Subject: Re: Longer command line for kexec on i386
Date: Wed, 25 Jul 2007 16:50:26 +0000 (UTC)
Message-ID: <loom.20070725T174305-393@post.gmane.org>
References: <loom.20070723T172709-232@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 68.166.32.218 (Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.5) Gecko/20070718 Fedora/2.0.0.5-1.fc7 Firefox/2.0.0.5)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ed Swierk <eswierk <at> arastra.com> writes:

> I made the following change to kexec:
>
> [deleted]
> 
> but I'm now seeing intermittent corruption of the initrd in the new kernel--a
> few bytes at different locations each time.
> 
> I suspect I've neglected some other important changes to the boot protocol.  

The corruption is due to a "hardware" bug (qemu), which was in fact corrupting
memory (http://article.gmane.org/gmane.comp.emulators.qemu/18774).  Extending
the command line in kexec somehow made the corruption noticeable.

--Ed


