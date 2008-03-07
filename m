Return-Path: <linux-kernel-owner+w=401wt.eu-S1762106AbYCGJCH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762106AbYCGJCH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 04:02:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756562AbYCGJBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 04:01:52 -0500
Received: from smtp-out.google.com ([216.239.45.13]:61743 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756213AbYCGJBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 04:01:51 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=rF9GjNzqw3YZG24bs0yty3Mc3ZapJ2s1A3zuDUcw8VSYajPwWqvOtcoVqYKGDqSu3
	5nBRBTyEZigmzMdobz2YA==
Message-ID: <6599ad830803070101t18c4814jeabf9c8a10a35dc5@mail.gmail.com>
Date: Fri, 7 Mar 2008 01:01:48 -0800
From: "Paul Menage" <menage@google.com>
To: "David Rientjes" <rientjes@google.com>
Subject: Re: [PATCH] Add cgroup support for enabling controllers at boot time
Cc: "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Pavel Emelianov" <xemul@openvz.org>, "Hugh Dickins" <hugh@veritas.com>,
       "Sudhir Kumar" <skumar@linux.vnet.ibm.com>,
       "YAMAMOTO Takashi" <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.DEB.1.00.0803070055020.3470@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080306185952.23290.49571.sendpatchset@localhost.localdomain>
	 <alpine.DEB.1.00.0803061108370.13110@chino.kir.corp.google.com>
	 <47D0C76D.8050207@linux.vnet.ibm.com>
	 <alpine.DEB.1.00.0803062111560.26462@chino.kir.corp.google.com>
	 <6599ad830803070040i5e54f5f3u9b4c753ac5a87771@mail.gmail.com>
	 <alpine.DEB.1.00.0803070055020.3470@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 7, 2008 at 12:56 AM, David Rientjes <rientjes@google.com> wrote:
>
>  Ok, so the cgroup_disable= parameter should be a list of subsystem names
>  delimited by anything other than a space that the user wants disabled.
>  That makes more sense, thanks.
>

As the code stands now, it should be just a single name. Disabling
multiple subsystems requires multiple cgroup_disable= options.

Paul
