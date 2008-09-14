Return-Path: <linux-kernel-owner+w=401wt.eu-S1755074AbYINQn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755074AbYINQn7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 12:43:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753226AbYINQnu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 12:43:50 -0400
Received: from adsl-67-120-171-161.dsl.lsan03.pacbell.net ([67.120.171.161]:40505
	"HELO linuxace.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751977AbYINQnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 12:43:50 -0400
Date: Sun, 14 Sep 2008 09:43:49 -0700
From: Phil Oester <kernel@linuxace.com>
To: "Wennie V. Lagmay" <wlagmay@yanbulink.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Kernel upgarde causes IPTABLES SAME not working for me
Message-ID: <20080914164349.GA6664@linuxace.com>
References: <23541694.2961221393851646.JavaMail.root@mail.yanbulink.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23541694.2961221393851646.JavaMail.root@mail.yanbulink.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 14, 2008 at 03:04:11PM +0300, Wennie V. Lagmay wrote:
> Dear all, 
> 
> I am having a problem with the recent version of kernel (2.6.25-14-108) on Fedora Core 9 64 bit.
> I am trying to enable the NATting using SAME command but I am getting an error "Iptables: No chain/target match by this name" but with earlier version of linux 2.6.23.1-42 iptables with SAME target is working; "iptables -t nat -A POSTROUTING -s 192.168.10.0/24 -j SAME --to 10.10.10.1-10.10.10.2 --nodst"

The SAME target has been removed from the kernel, and no longer
exists in 2.6.25.  You will have to use the SNAT or MASQUERADE
targets.

Phil
