Return-Path: <linux-kernel-owner+w=401wt.eu-S932138AbZGOQJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932138AbZGOQJT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 12:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932126AbZGOQJS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 12:09:18 -0400
Received: from outbound-mail-126.bluehost.com ([67.222.38.26]:35079 "HELO
	outbound-mail-126.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932128AbZGOQJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 12:09:17 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=YlKeSrOPJ+Aw+tixMHj9UmlLFzVBtP8I2ZVcu4akrTd8YpkVhjIR5VIfDuMIxU23z1kKVsUjdFiFsxYNfXmZ3RsAQ3dmSnVoT/kvIqzEw4KyBQkHuMI0TYU7J0/bNpL2;
Date: Wed, 15 Jul 2009 09:09:13 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>,
       Jesse Brandeburg <jesse.brandeburg@gmail.com>
Subject: Re: linux-next: pci tree build failure
Message-ID: <20090715090913.5dfb96c2@jbarnes-g45>
In-Reply-To: <20090715114510.ebba4bd0.sfr@canb.auug.org.au>
References: <20090715114510.ebba4bd0.sfr@canb.auug.org.au>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Jul 2009 11:45:10 +1000
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Jesse,
> 
> Today's linux-next build (x86_64 allmodconfig) failed like this:
> 
> arch/x86/pci/common.c:619: error: expected '}' before ';' token
> 
> Caused by commit 1c6804b093f5753c2a23aa36f31f66966035bd32 ("x86/PCI:
> initialize PCI bus node numbers early").  This could not have been
> built with CONFIG_NUMA set ...
> 
> I have used the version of the pci tree from next-20090714 for today.

Arg, did I apply the patch w/o that fix?  Fixing now...

-- 
Jesse Barnes, Intel Open Source Technology Center
