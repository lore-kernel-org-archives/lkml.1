Return-Path: <linux-kernel-owner+w=401wt.eu-S1754897AbYCNLuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897AbYCNLuZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 07:50:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752116AbYCNLuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 07:50:15 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:53994 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751078AbYCNLuO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 07:50:14 -0400
X-Greylist: delayed 473 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Mar 2008 07:50:13 EDT
Message-ID: <405494956.21991@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Fri, 14 Mar 2008 19:42:15 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, jack@suse.cz,
       chris@linuxinfotag.de
Subject: Re: [PATCH][BUG 10227] readahead ret value fix
References: <20080314104906.GA2898@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080314104906.GA2898@darkstar.te-china.tietoenator.com>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.17 (2007-11-01)
Message-Id: <E1Ja8Ih-0005kr-0V@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2008 at 06:49:06PM +0800, Dave Young wrote:
> If the page_offset > end_index, the return value should be updated to 0,
> avoiding the redundant read_pages

No, we don't need to fix it, hehe.
It's really trivial overhead.

The principle is to not add dispensable code :-)

Thank you,
Fengguang

