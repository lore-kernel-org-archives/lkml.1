Return-Path: <linux-kernel-owner+w=401wt.eu-S1753097AbXCMCZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753097AbXCMCZw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 22:25:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753095AbXCMCZw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 22:25:52 -0400
Received: from smtp-out.google.com ([216.239.33.17]:44312 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097AbXCMCZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 22:25:51 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=LBaDCalyuWyDGeQWEuO7zO2YSllTwutG/rs7xM6pKxI3aOKwjAHF8OhfoDmeIzs7K
	lpJuudK3VcIOQAgd9OCJg==
Message-ID: <6599ad830703121925p7049db95nccedfc32609e6ae6@mail.gmail.com>
Date: Mon, 12 Mar 2007 19:25:48 -0700
From: "Paul Menage" <menage@google.com>
To: "Paul Menage" <menage@google.com>, "Paul Jackson" <pj@sgi.com>,
       ebiederm@xmission.com, matthltc@us.ibm.com,
       ckrm-tech@lists.sourceforge.net, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       winget@google.com, xemul@sw.ru
Subject: Re: [ckrm-tech] [PATCH 0/2] resource control file system - aka containers on top of nsproxy!
In-Reply-To: <20070312232143.GC6832@MAIL.13thfloor.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6599ad830703071658q60466dd8hd18a1eab9bc17535@mail.gmail.com>
	 <6599ad830703071857yf711921ja3440c4276bbe58e@mail.gmail.com>
	 <45EF83CB.9080903@vilain.net>
	 <1173334209.13172.61.camel@localhost.localdomain>
	 <m11wk08c9h.fsf@ebiederm.dsl.xmission.com>
	 <20070309010628.GE4506@MAIL.13thfloor.at>
	 <45F27503.1020108@vilain.net> <20070311141555.9951b7ba.pj@sgi.com>
	 <6599ad830703120300x63ca5732wfe865f76cb5125a9@mail.gmail.com>
	 <20070312232143.GC6832@MAIL.13thfloor.at>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/12/07, Herbert Poetzl <herbert@13thfloor.at> wrote:
>
> why? you simply enter that specific space and
> use the existing mechanisms (netlink, proc, whatever)
> to retrieve the information with _existing_ tools,

That's assuming that you're using network namespace virtualization,
with each group of tasks in a separate namespace. What if you don't
want the virtualization overhead, just the accounting?

Paul
