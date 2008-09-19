Return-Path: <linux-kernel-owner+w=401wt.eu-S1757217AbYISJBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757217AbYISJBU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 05:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751108AbYISJBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 05:01:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57505 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751164AbYISJBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 05:01:04 -0400
Date: Fri, 19 Sep 2008 02:00:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wojciech Kromer <wojciech.kromer@dgt.com.pl>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-nfs@vger.kernel.org
Subject: Re: NFS root + iptables in 2.6.25
Message-Id: <20080919020057.f2f256fe.akpm@linux-foundation.org>
In-Reply-To: <48D3451D.1080807@dgt.com.pl>
References: <48D3451D.1080807@dgt.com.pl>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Sep 2008 08:22:21 +0200 Wojciech Kromer <wojciech.kromer@dgt.com.pl> wrote:

> Hi.
> 
> I'm using nfs root filesystem for developing.
> On 2.6.23 everything works fine, but on 2.6.25 loading any iptables
> module causes problems:
> 
> 
> # modprobe iptable_nat
> nf_conntrack version 0.5.0 (1024 buckets, 4096 max)
> nfs: RPC call returned error 1
> nfs: RPC call returned error 1
> nfs: RPC call returned error 1
> nfs: RPC call returned error 1
> nfs: RPC call returned error 1
> nfs: RPC call returned error 1
> 
> 
> Probably iptables changed it's default behavior from "allow all" to
> "deny all" at startup.
> Is there any way to change it back?
> I can't change anything after loading any iptable module, because all
> programs on filesystem are not accessible after loading...
> 
> 

(cc's added)

(googles "nfs: RPC call returned error 1")

hm, there has been a dribble of reports going back several years, but
nothing conclusive afaict.

