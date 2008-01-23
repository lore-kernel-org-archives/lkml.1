Return-Path: <linux-kernel-owner+w=401wt.eu-S1753644AbYAWITq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644AbYAWITq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 03:19:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750942AbYAWITi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 03:19:38 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:45490 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbYAWITh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 03:19:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=YqPZApBzCw4T+MkcEdrORLnWEIkTPgYLc2xyxpVwxI7zfEo5aIEWOjv/SIMjLRrBPRayLzm8KQYbS6EtR+RlxlhtvVsmCqSNQgRaegNSpCAuGI1C2N6UKE5vZxnvlt7jswdmhXabzY0pBDCIf4itwGwEWgJ5pAyJdZDPk+kXszw=
Message-ID: <84144f020801230019i5ac6c8b1lfa5364672988b0c4@mail.gmail.com>
Date: Wed, 23 Jan 2008 10:19:33 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Christoph Lameter" <clameter@sgi.com>
Subject: Re: crash in kmem_cache_init
Cc: "Mel Gorman" <mel@csn.ul.ie>, "Olaf Hering" <olaf@aepfle.de>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "hanth Aravamudan" <nacc@us.ibm.com>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       lee.schermerhorn@hp.com, "Linux MM" <linux-mm@kvack.org>,
       akpm@linux-foundation.org
In-Reply-To: <Pine.LNX.4.64.0801221517260.2871@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0801171049190.21058@schroedinger.engr.sgi.com>
	 <20080118225713.GA31128@aepfle.de> <20080122195448.GA15567@csn.ul.ie>
	 <Pine.LNX.4.64.0801221203340.27950@schroedinger.engr.sgi.com>
	 <20080122212654.GB15567@csn.ul.ie>
	 <Pine.LNX.4.64.0801221330390.1652@schroedinger.engr.sgi.com>
	 <20080122225046.GA866@csn.ul.ie> <47967560.8080101@cs.helsinki.fi>
	 <Pine.LNX.4.64.0801221501240.2565@schroedinger.engr.sgi.com>
	 <Pine.LNX.4.64.0801221517260.2871@schroedinger.engr.sgi.com>
X-Google-Sender-Auth: 36ca8367a9f0af10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

On Jan 23, 2008 1:18 AM, Christoph Lameter <clameter@sgi.com> wrote:
> My patch is useless (fascinating history of the changelog there through).
> fallback_alloc calls kmem_getpages without GFP_THISNODE. This means that
> alloc_pages_node() will try to allocate on the current node but fallback
> to neighboring node if nothing is there....

Sure, but I was referring to the scenario where current node _has_
pages available but no ->nodelists. Olaf, did you try it?

                        Pekka
