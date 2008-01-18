Return-Path: <linux-kernel-owner+w=401wt.eu-S932103AbYARWUQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932103AbYARWUQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 17:20:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761447AbYARWT7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 17:19:59 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:20366 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760670AbYARWT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 17:19:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=UT2flm8NruiS/qwGExDzrWt6AODWonL4evGjnOEOJVncha4FF9qGzC+dIwKi2i5RHzy7l3fskBI3FZzRJpD0AE0KMLKfJnJ3batp+GC0U5TlOe5iA8db9P2I5IlqoBh2+4Q39y3W55ObptwcmMJgBHqRCHSAn945d3V4p67rsPQ=
Message-ID: <29495f1d0801181419q7ec24cc2v3843e5eba27fe207@mail.gmail.com>
Date: Fri, 18 Jan 2008 14:19:54 -0800
From: "Nish Aravamudan" <nish.aravamudan@gmail.com>
To: "Christoph Lameter" <clameter@sgi.com>
Subject: Re: crash in kmem_cache_init
Cc: "Olaf Hering" <olaf@aepfle.de>, "Mel Gorman" <mel@csn.ul.ie>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "hanth Aravamudan" <nacc@us.ibm.com>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       lee.schermerhorn@hp.com, "Linux MM" <linux-mm@kvack.org>
In-Reply-To: <Pine.LNX.4.64.0801181414200.8924@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080115150949.GA14089@aepfle.de>
	 <84144f020801170414q7d408a74uf47a84b777c36a4a@mail.gmail.com>
	 <Pine.LNX.4.64.0801170628580.19208@schroedinger.engr.sgi.com>
	 <20080117181222.GA24411@aepfle.de>
	 <Pine.LNX.4.64.0801171049190.21058@schroedinger.engr.sgi.com>
	 <20080117211511.GA25320@aepfle.de>
	 <Pine.LNX.4.64.0801181043290.30348@schroedinger.engr.sgi.com>
	 <20080118213011.GC10491@csn.ul.ie>
	 <Pine.LNX.4.64.0801181414200.8924@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/18/08, Christoph Lameter <clameter@sgi.com> wrote:
> Could you try this patch?
>
> Memoryless nodes: Set N_NORMAL_MEMORY for a node if we do not support
> HIGHMEM
>
> It seems that we only scan through zones to set N_NORMAL_MEMORY only if
> CONFIG_HIGHMEM and CONFIG_NUMA are set. We need to set
> N_NORMAL_MEMORY
> in the !CONFIG_HIGHMEM case.

I'm testing this exact patch right now on the machine Mel saw the issues with.

Thanks,
Nish
