Return-Path: <linux-kernel-owner+w=401wt.eu-S1755355AbYDEXaB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355AbYDEXaB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2008 19:30:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751239AbYDEX3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Apr 2008 19:29:51 -0400
Received: from smtp-out.google.com ([216.239.33.17]:21218 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141AbYDEX3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2008 19:29:51 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=s39A/pNwm9C5Mj7svMZoonjPmpcSULN75mhSqjYQVzrju1XOSVmDImzq3+KBPk935
	iUaHMVKNMQorfodNkj0Yw==
Message-ID: <6599ad830804051629k3649dbc4na92bb3d0cd7a0492@mail.gmail.com>
Date: Sat, 5 Apr 2008 16:29:35 -0700
From: "Paul Menage" <menage@google.com>
To: balbir@linux.vnet.ibm.com
Subject: Re: [-mm] Add an owner to the mm_struct (v8)
Cc: "Pavel Emelianov" <xemul@openvz.org>, "Hugh Dickins" <hugh@veritas.com>,
       "Sudhir Kumar" <skumar@linux.vnet.ibm.com>,
       "YAMAMOTO Takashi" <yamamoto@valinux.co.jp>,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       "David Rientjes" <rientjes@google.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <47F7CC08.4090209@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080404080544.26313.38199.sendpatchset@localhost.localdomain>
	 <47F5E69C.9@linux.vnet.ibm.com>
	 <6599ad830804040150j4946cf92h886bb26000319f3b@mail.gmail.com>
	 <47F5F3FA.7060709@linux.vnet.ibm.com>
	 <6599ad830804041211r37848a6coaa900d8bdac40fbe@mail.gmail.com>
	 <47F79102.6090406@linux.vnet.ibm.com>
	 <6599ad830804051023v69caa3d4h6e26ccb420bca899@mail.gmail.com>
	 <47F7BB69.3000502@linux.vnet.ibm.com>
	 <6599ad830804051057n2f2802e4w6179f2e108467494@mail.gmail.com>
	 <47F7CC08.4090209@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 5, 2008 at 11:59 AM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>  > But surely the performance of thread exits wouldn't be affected by the
>  > delay_group_leader(p) change, since none of the exiting threads would
>  > be a group leader. That optimization only matters when the entire
>  > process exits.
>  >
>
>  On the client side, each JVM instance exits after the test. I see the thread
>  group leader exit as well through getdelays (I see TGID exits).

How long does the test run for? How many threads does each client have?

Paul
