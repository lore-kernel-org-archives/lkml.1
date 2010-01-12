Return-Path: <linux-kernel-owner+w=401wt.eu-S1754572Ab0ALQb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572Ab0ALQb1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 11:31:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754298Ab0ALQb0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 11:31:26 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:42712 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754231Ab0ALQbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 11:31:25 -0500
Date: Tue, 12 Jan 2010 08:30:13 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, albin.tonnerre@free-electrons.com
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for January 12 (unlzo)
Message-Id: <20100112083013.1dad8a8d.randy.dunlap@oracle.com>
In-Reply-To: <20100112171739.2011a0eb.sfr@canb.auug.org.au>
References: <20100112171739.2011a0eb.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4B4CA3D0.025D:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Jan 2010 17:17:39 +1100 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20100109:



arch/x86/boot/compressed/../../../../lib/decompress_unlzo.c:53: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'parse_header'
arch/x86/boot/compressed/../../../../lib/decompress_unlzo.c:90: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'unlzo'

Problem is the "INIT" there, seems to be undefined.

---
~Randy
