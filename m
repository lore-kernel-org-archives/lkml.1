Return-Path: <linux-kernel-owner+w=401wt.eu-S1751865AbXLAHsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865AbXLAHsj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 02:48:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751050AbXLAHsZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 02:48:25 -0500
Received: from smtp-out.google.com ([216.239.33.17]:20752 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbXLAHsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 02:48:24 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=oCENqDuCTv32I9a4oDzXTH1zA8ve3DomtNTRBs43CprySEMXDISxIfWcVEnq0WDYv
	mvL/sxays0j6CBTv+tD+Q==
Message-ID: <6599ad830711302348n49900ca8jfa66fa71fde76a67@mail.gmail.com>
Date: Fri, 30 Nov 2007 23:48:15 -0800
From: "Paul Menage" <menage@google.com>
To: vatsa@linux.vnet.ibm.com
Subject: Re: [PATCH] sched: cpu accounting controller (V2)
Cc: "Andrew Morton" <akpm@linux-foundation.org>, dhaval@linux.vnet.ibm.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       skumar@linux.vnet.ibm.com, torvalds@linux-foundation.org, mingo@elte.hu,
       balbir@linux.vnet.ibm.com
In-Reply-To: <20071130124225.GM5681@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6599ad830711122125u576e85a6w428466a0ab46dbc6@mail.gmail.com>
	 <20071113060038.GC3359@linux.vnet.ibm.com>
	 <6599ad830711122205g88aae4fua8dd76cf6e8ab84d@mail.gmail.com>
	 <20071113074805.GA13499@linux.vnet.ibm.com>
	 <6599ad830711122357i60482475o10c0e0935a9e00c0@mail.gmail.com>
	 <20071129191737.GH5681@linux.vnet.ibm.com>
	 <20071129113035.bbdf35db.akpm@linux-foundation.org>
	 <20071129201833.GA18023@linux.vnet.ibm.com>
	 <20071130124225.GM5681@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vatsa,

Thanks, this looks pretty good.

On Nov 30, 2007 4:42 AM, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com> wrote:
>
>         - Removed load average information. I felt it needs more thought (esp
>           to deal with SMP and virtualized platforms) and can be added for
>           2.6.25 after more discussions.

The "load" value was never a load average, it was just a count of the
% cpu time used in the previous fixed window of time, updated at the
end of each window.

Maybe we can instead do something based tracking the length of the run
queue for the cgroup?

Paul
