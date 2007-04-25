Return-Path: <linux-kernel-owner+w=401wt.eu-S1161607AbXDYFAF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161607AbXDYFAF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 01:00:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161608AbXDYFAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 01:00:05 -0400
Received: from smtp-out.google.com ([216.239.45.13]:5735 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161607AbXDYFAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 01:00:01 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=LgBEXWH7WUsSsOiyNn45e0vMJYm0HCAeJIbTHvf23xACUVnXzXImi3MXNvZqbNKtO
	GSMMUYKmp9Jz+s/DheErg==
Message-ID: <6599ad830704242159k6f889c51v104aeb863b04d5e3@mail.gmail.com>
Date: Tue, 24 Apr 2007 21:59:40 -0700
From: "Paul Menage" <menage@google.com>
To: "Vaidyanathan Srinivasan" <svaidy@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/7] Containers (V8): Cpusets hooked into containers
Cc: akpm@linux-foundation.org, sekharan@us.ibm.com, dev@sw.ru, xemul@sw.ru,
       serue@us.ibm.com, vatsa@in.ibm.com, ebiederm@xmission.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, mbligh@google.com, rohitseth@google.com,
       devel@openvz.org
In-Reply-To: <462C9001.7060403@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070406233221.989528000@menage.corp.google.com>
	 <20070407001324.090764000@menage.corp.google.com>
	 <462C9001.7060403@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/23/07, Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com> wrote:
> >
> >  config CONTAINERS
> > -     bool "Container support"
> > -     help
> > -       This option will let you create and manage process containers,
> > -       which can be used to aggregate multiple processes, e.g. for
> > -       the purposes of resource tracking.
> > -
> > -       Say N if unsure
> > +     bool
>
> Hi Paul,
>
> This looks like some patch generation error.  Description for
> containers should not be removed after applying this patch.

No, this is intentional - in the first patch in the series,
CONFIG_CONTAINER was a user-selectable option so it had a description;
in the second it becomes an option that's only selected if other
selected systems (e.g. cpusets) depend on it. So it no longer needs
help text.

Cheers,

Paul
