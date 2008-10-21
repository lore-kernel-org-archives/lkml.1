Return-Path: <linux-kernel-owner+w=401wt.eu-S1753425AbYJUIke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425AbYJUIke (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 04:40:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751739AbYJUIk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 04:40:27 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62548 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751328AbYJUIk0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 04:40:26 -0400
Message-ID: <48FD9570.8080406@cn.fujitsu.com>
Date: Tue, 21 Oct 2008 16:40:16 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Cedric Le Goater <clg@fr.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Containers <containers@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] freezer_cg: use thaw_process() in unfreeze_cgroup()
References: <48FD26F5.1070809@cn.fujitsu.com> <48FD273F.3040505@cn.fujitsu.com> <48FD2784.30906@cn.fujitsu.com> <48FD81B8.5030103@fr.ibm.com>
In-Reply-To: <48FD81B8.5030103@fr.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cedric Le Goater wrote:
> Li Zefan wrote:
>> Don't duplicate the implementation of thaw_process().
> 
> looks OK but you should remove  __thaw_process() which is unused 
> now.
> 

Then I'll make it a static function and remove the declaration from .h file.

