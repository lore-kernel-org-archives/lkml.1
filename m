Return-Path: <linux-kernel-owner+w=401wt.eu-S1755473AbYHSJtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473AbYHSJtS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 05:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752940AbYHSJtH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 05:49:07 -0400
Received: from gv-out-0910.google.com ([216.239.58.191]:53699 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857AbYHSJtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 05:49:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=UFxZZuAgw3eQLYvJSK0W9zM/0KvtfVWS47FqdtxJJkHZThJvqOxLEcMxqNPbFElaf1
         xPO5H2ZXDWPKH0vqLDCfg+L96NcaVt8XpBxC+CUP9aiKWTValLSqgND4EnYXTcM+hwuT
         Fbi4WTtC7/Wx8XeR0tMtTJSQA4qIBR9Xz9ZDg=
Message-ID: <48AA970D.5050403@gmail.com>
Date: Tue, 19 Aug 2008 11:49:01 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: balbir@linux.vnet.ibm.com
CC: Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] mm_owner: fix cgroup null dereference
References: <1218745013-9537-1-git-send-email-jirislaby@gmail.com> <48A49C78.7070100@linux.vnet.ibm.com> <48A9E82E.3060009@gmail.com> <48AA4003.5080300@linux.vnet.ibm.com>
In-Reply-To: <48AA4003.5080300@linux.vnet.ibm.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19/2008 05:37 AM, Balbir Singh wrote:
> Could you please help me with the steps to reproduce the problem.  I don't seem
> to be hitting the mm->owner changed callback. I did have a test case for it when
> I developed mm->owner functionality, but it does not trigger an oops for me.

I have no idea. My config is at:
http://decibel.fi.muni.cz/~xslaby/config-memrlimit-oops
I don't play with cgroups or anything, I just work on the system. Do you need a
test case, it's obvious from the code as far as I can see?
