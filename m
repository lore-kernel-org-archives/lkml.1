Return-Path: <linux-kernel-owner+w=401wt.eu-S1761029AbZAHRYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761029AbZAHRYZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 12:24:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751527AbZAHRYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 12:24:10 -0500
Received: from rcsinet13.oracle.com ([148.87.113.125]:43190 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599AbZAHRYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 12:24:08 -0500
Message-ID: <496636AB.9000903@oracle.com>
Date: Thu, 08 Jan 2009 09:23:55 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for January 8 (percpu)
References: <20090108171730.19a41e14.sfr@canb.auug.org.au>
In-Reply-To: <20090108171730.19a41e14.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt707.oracle.com [141.146.40.85]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.496636AF.0185:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20090107:
> 
> Undropped tree:
> 	rr
> 
> Dropped trees (temporarily):
> 	ocfs2 (build problem)
> 	cpu_alloc (build problem)


When CONFIG_SMP=n, both arch/x86/include/asm/percpu.h and
include/asm-generic/percpu.h define both of
read_percpu_ptr() and read_percpu_var().


build-r8079.out:linux-next-20090108/include/asm-generic/percpu.h:124:1: warning: "read_percpu_ptr" redefined
build-r8079.out:linux-next-20090108/arch/x86/include/asm/percpu.h:107:1: warning: this is the location of the previous definition
build-r8079.out:linux-next-20090108/include/asm-generic/percpu.h:120:1: warning: "read_percpu_var" redefined
build-r8079.out:linux-next-20090108/arch/x86/include/asm/percpu.h:106:1: warning: this is the location of the previous definition



-- 
~Randy
