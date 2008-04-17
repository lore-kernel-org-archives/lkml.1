Return-Path: <linux-kernel-owner+w=401wt.eu-S934150AbYDQSCa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934150AbYDQSCa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 14:02:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762704AbYDQSCV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 14:02:21 -0400
Received: from wr-out-0506.google.com ([64.233.184.237]:15228 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762584AbYDQSCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 14:02:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DhrM0hi5HS095n/umdUHAeeQ9b945gSHEvlczcJUxAaPWLtksXmp06PFCgk7SfPy9C+Mt7jF99h0Vrh00FlwbEDCuxb1I1om2bzHinmbmTb0d7T2Y7pFJ+JJK/2+c31ln0RkZzs3JmKB9LcrEz65GeOtOyFdKgttqwAffPbZWfE=
Message-ID: <86802c440804171102q2be96c67m881394c1e6fa3867@mail.gmail.com>
Date: Thu, 17 Apr 2008 11:02:13 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Mike Travis" <travis@sgi.com>
Subject: Re: [PATCH] - Increase MAX_APICS for large configs
Cc: "Jack Steiner" <steiner@sgi.com>, tglx@linutronix.de, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20080417110727.GA942@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080416163936.GA23099@sgi.com> <20080417110727.GA942@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2008 at 4:07 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
>  * Jack Steiner <steiner@sgi.com> wrote:
>
>  > Increase the maximum number of apics when running very large
>  > configurations. This patch has no affect on most systems.
>
>  x86.git overnight random-qa testing found a boot crash and i bisected it
>  down to this patch. The config is:
>
>   http://redhat.com/~mingo/misc/config-Thu_Apr_17_10_17_14_CEST_2008.bad
>
>  the failure is attached below. (I needed the exact boot parameters
>  listed in that bootup log to see this failure.)
>
>  it seems to be CONFIG_MAXSMP=y triggers the new more-apic-ids code and
>  that causes some breakage elsewhere. [btw., this again shows how useful
>  the CONFIG_MAXSMP debug feature is!]

so this one and Mike's 4096 NR_CPUS cause the problem?

2048 CPUs works.

YH
