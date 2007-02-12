Return-Path: <linux-kernel-owner+w=401wt.eu-S1030470AbXBLXQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030470AbXBLXQA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 18:16:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030471AbXBLXQA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 18:16:00 -0500
Received: from smtp-out.google.com ([216.239.45.13]:18560 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030470AbXBLXP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 18:15:59 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=o31X5GVAQZ9Gv5guzwiS17onB6ocH+uR1mQqMs6YAd2RnZccv4qo0J2WcyCHGp18T
	EsYz18JD+fJghTDNP87hQ==
Message-ID: <6599ad830702121515p10bc1b58kf1d29367b9b18016@mail.gmail.com>
Date: Mon, 12 Feb 2007 15:15:51 -0800
From: "Paul Menage" <menage@google.com>
To: "Sam Vilain" <sam@vilain.net>
Subject: Re: [PATCH 0/7] containers (V7): Generic Process Containers
Cc: akpm@osdl.org, pj@sgi.com, sekharan@us.ibm.com, dev@sw.ru, xemul@sw.ru,
       serue@us.ibm.com, vatsa@in.ibm.com, ebiederm@xmission.com,
       containers@lists.osdl.org, winget@google.com, rohitseth@google.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <45D0EC68.9090009@vilain.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070212081521.808338000@menage.corp.google.com>
	 <45D0EC68.9090009@vilain.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/12/07, Sam Vilain <sam@vilain.net> wrote:
>
> I know I'm a bit out of touch, but AIUI the NSProxy *is* the container.
> We decided a long time ago that a container was basically just a set of
> namespaces, which includes all of the subsystems you mention.

You may have done that, but the CKRM/ResGroups independently decided a
long time ago that the fundamental unit was the resource class, and
the OpenVZ folks decided that the fundamental unit was the
BeanCounter, and the CPUSet folks decided that the fundamental unit
was the CPUSet, etc ... :-)

But there's a lot of common ground between these different approaches,
and potential for synergy, so the point of this patch set is to
provide a unification point for all of them, and a stepping stone for
other new resource controllers and process control modules.

Paul
