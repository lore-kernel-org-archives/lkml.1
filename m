Return-Path: <linux-kernel-owner+w=401wt.eu-S933606AbXBYBrn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933606AbXBYBrn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 20:47:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933608AbXBYBrn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 20:47:43 -0500
Received: from wx-out-0506.google.com ([66.249.82.228]:9746 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933606AbXBYBrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 20:47:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=AoDlUQKhixLnRLr+ktxePhl5sX/zjwjLVD/FciZwGINaBJzqzmtdDVUzjmyplNaPkhEYE0L/1EQo7KuAtLEgqKEjuvf5jHV9f/Iwirl6g18PkIMrL2e96+Qc3rWyLuKLF1h5H/NihIdwLi9UQfI/aouOiPnvVug7LEhwWf21bV8=
Message-ID: <4df04b840702241747ne903699w636d37b40351b752@mail.gmail.com>
Date: Sun, 25 Feb 2007 09:47:41 +0800
From: "yunfeng zhang" <zyf.zeroos@gmail.com>
To: "Rik van Riel" <riel@redhat.com>
Subject: Re: [PATCH 2.6.20-rc5 1/1] MM: enhance Linux swap subsystem
Cc: linux-kernel@vger.kernel.org, "Hugh Dickins" <hugh@veritas.com>,
       linux-mm@kvack.org
In-Reply-To: <45DE6080.6030904@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4df04b840701212309l2a283357jbdaa88794e5208a7@mail.gmail.com>
	 <Pine.LNX.4.64.0701242015090.1770@blonde.wat.veritas.com>
	 <4df04b840701301852i41687edfl1462c4ca3344431c@mail.gmail.com>
	 <Pine.LNX.4.64.0701312022340.26857@blonde.wat.veritas.com>
	 <4df04b840702122152o64b2d59cy53afcd43bb24cb7a@mail.gmail.com>
	 <4df04b840702200106q670ff944k118d218fed17b884@mail.gmail.com>
	 <4df04b840702211758t1906083x78fb53b6283349ca@mail.gmail.com>
	 <45DCFDBE.50209@redhat.com>
	 <4df04b840702221831x76626de1rfa70cb653b12f495@mail.gmail.com>
	 <45DE6080.6030904@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

To a two-CPU architecture, its page distribution just like theoretically

ABABAB....

So every readahead of A process will create 4 unused readahead pages unless you
are sure B will resume soon.

Have you ever compared the results among UP, 2 or 4-CPU?
