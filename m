Return-Path: <linux-kernel-owner+w=401wt.eu-S1756192AbZGMP1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192AbZGMP1s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 11:27:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755948AbZGMP1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 11:27:47 -0400
Received: from smtp-out.google.com ([216.239.45.13]:48705 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756058AbZGMP1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 11:27:47 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=T8w2/yhtlstabbcW+X+9F/E1buqA8SW1w00p4JIdv3Xp5/2u5V317ERv0D0BGClOb
	QgpnhSpM/fMdL02Qoi7vw==
MIME-Version: 1.0
In-Reply-To: <20090713150303.70ab5176.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090710230043.16778.29656.stgit@hastromil.mtv.corp.google.com>
	 <20090710230205.16778.11707.stgit@hastromil.mtv.corp.google.com>
	 <4A5AA3E7.9070800@cn.fujitsu.com>
	 <20090713150303.70ab5176.kamezawa.hiroyu@jp.fujitsu.com>
Date: Mon, 13 Jul 2009 11:27:43 -0400
Message-ID: <2f86c2480907130827u7d2b062bw26bbb80a8e3de657@mail.gmail.com>
Subject: Re: [PATCH 3/3] Quick vmalloc vs kmalloc fix to the case where array 
	size is too large
From: Benjamin Blum <bblum@google.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, akpm@linux-foundation.org,
       serue@us.ibm.com, menage@google.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 13, 2009 at 2:03 AM, KAMEZAWA
Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> ???? why not using vmalloc() always ?
>
> Thanks,
> -Kame
>

The idea behind this patch is that in most cases, we want to use
kmalloc for performance, but sometimes the array will be too big. See
the previous thread (linked in the root message of this thread) for
discussion of the issue.
