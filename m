Return-Path: <linux-kernel-owner+w=401wt.eu-S1760259AbZCCA0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760259AbZCCA0b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 19:26:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753854AbZCCA0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 19:26:21 -0500
Received: from smtp-out.google.com ([216.239.33.17]:28436 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532AbZCCA0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 19:26:20 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=Bo2FgjakcyiD9ZWHebQz5Vc++Cy/lOShL6RyHclUcBRE/RlM/q0MhwJdMJVc8FOoe
	5j4KMATk2uq61TvNpo57Q==
MIME-Version: 1.0
In-Reply-To: <49AC789D.5050209@google.com>
References: <49AB40BF.4030706@cn.fujitsu.com>
	 <6599ad830903021019p3b29c173oc7772af6679d90e0@mail.gmail.com>
	 <20090303090950.60cea53a.kamezawa.hiroyu@jp.fujitsu.com>
	 <6599ad830903021615j6e1380e2l1544b67b187c1f5e@mail.gmail.com>
	 <20090303092021.93e69b96.kamezawa.hiroyu@jp.fujitsu.com>
	 <49AC789D.5050209@google.com>
Date: Mon, 2 Mar 2009 16:26:15 -0800
Message-ID: <6599ad830903021626jb1be89wc872ef7dee0a542e@mail.gmail.com>
Subject: Re: [PATCH 0/4] cgroups: show correct file mode
From: Paul Menage <menage@google.com>
To: Mike Waychison <mikew@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Containers <containers@lists.linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Linux@smtp1.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 2, 2009 at 4:23 PM, Mike Waychison <mikew@google.com> wrote:
>>>  if (cft->write_xxx || ....)
>>>    mode |= 0600;
>
> 0200 ?

Oops (again). Yes, that's what I meant. Coding in email considered harmful :-)

Paul
