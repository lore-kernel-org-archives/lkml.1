Return-Path: <linux-kernel-owner+w=401wt.eu-S1753028AbZHKMFK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753028AbZHKMFK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 08:05:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752986AbZHKMFJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 08:05:09 -0400
Received: from main.gmane.org ([80.91.229.2]:36569 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752940AbZHKMFH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 08:05:07 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
Subject: Re: case-duplicated filenames
Date: Tue, 11 Aug 2009 03:35:46 +0100
Message-ID: <yw1x7hxb84cd.fsf@unicorn.mansr.com>
References: <a9c5028086c7f5f0e245853b9065e187.squirrel@ubb.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: unicorn.mansr.com
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.22 (Instant Classic, linux)
Cancel-Lock: sha1:ivaDpodZKlkN0J5wl/zbkWoRLqM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Tony Mantler" <nicoya@ubb.ca> writes:

> A co-worker reminded me this afternoon that the linux source tree does not
> get along well with case-insensitive filesystems. Ever the curious and
> bored sort, and in the middle of an sqlite bender, I decided to cook up a
> quick script to find exactly what files those are.
>
> The results (in lowercase) are as follows:
> [22 files]
>
> And the script, if you'd like to run it yourself, is as follows (hereby
> released GPL2):
> [SQL]

Everybody know the shell is the hackers best friend:

$ git ls-files | tr A-Z a-z | sort | uniq -d
documentation/io-mapping.txt
include/linux/netfilter/xt_connmark.h
include/linux/netfilter/xt_dscp.h
include/linux/netfilter/xt_mark.h
include/linux/netfilter/xt_rateest.h
include/linux/netfilter/xt_tcpmss.h
include/linux/netfilter_ipv4/ipt_connmark.h
include/linux/netfilter_ipv4/ipt_dscp.h
include/linux/netfilter_ipv4/ipt_ecn.h
include/linux/netfilter_ipv4/ipt_mark.h
include/linux/netfilter_ipv4/ipt_tcpmss.h
include/linux/netfilter_ipv4/ipt_tos.h
include/linux/netfilter_ipv4/ipt_ttl.h
include/linux/netfilter_ipv6/ip6t_hl.h
include/linux/netfilter_ipv6/ip6t_mark.h
net/ipv4/netfilter/ipt_ecn.c
net/netfilter/xt_connmark.c
net/netfilter/xt_dscp.c
net/netfilter/xt_hl.c
net/netfilter/xt_mark.c
net/netfilter/xt_rateest.c
net/netfilter/xt_tcpmss.c

That runs in about 0.03 seconds here.

-- 
Måns Rullgård
mans@mansr.com

