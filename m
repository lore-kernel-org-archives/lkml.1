Return-Path: <linux-kernel-owner+w=401wt.eu-S1753346AbZBUM6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346AbZBUM6T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 07:58:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751538AbZBUM6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 07:58:05 -0500
Received: from aa011msr.fastwebnet.it ([85.18.95.71]:42265 "EHLO
	aa011msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084AbZBUM6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 07:58:04 -0500
X-Greylist: delayed 328 seconds by postgrey-1.27 at vger.kernel.org; Sat, 21 Feb 2009 07:58:04 EST
Date: Sat, 21 Feb 2009 13:52:33 +0100
From: Paolo Ornati <ornati@fastwebnet.it>
To: Paolo Ornati <ornati@fastwebnet.it>
Cc: Sitsofe Wheeler <sitsofe@yahoo.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Eric Anholt <eric@anholt.net>, Dave Airlie <airlied@linux.ie>
Subject: Re: [BISECTED] [drm:i915_initialize] *ERROR* can not ioremap
 virtual address for ring buffer
Message-ID: <20090221135233.58fbae0b@fastwebnet.it>
In-Reply-To: <20090221134933.368c2709@fastwebnet.it>
References: <20090221110011.030cb16d@fastwebnet.it>
	<20090221121944.GA21090@silver.sucs.org>
	<20090221134933.368c2709@fastwebnet.it>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Feb 2009 13:49:33 +0100
Paolo Ornati <ornati@fastwebnet.it> wrote:

> On Sat, 21 Feb 2009 12:19:44 +0000
> Sitsofe Wheeler <sitsofe@yahoo.com> wrote:
> 
> > On Sat, Feb 21, 2009 at 11:00:11AM +0100, Paolo Ornati wrote:
> > > 
> > > Booting current -git with that commit reverted (good) and not reverted
> > > (bad), with "fastboot initcall_debug" I've noticed mtrr change:
> > 
> > Does this happen when you enable the mtrr cleaner? -
> > http://marc.info/?l=linux-kernel&m=123501581629566&w=2

Ah, you were taliking abount the "/proc/mtrr" change...

It's a "yes, it still happens" anyway:

$ cat /proc/mtrr
reg00: base=0x000000000 (    0MB), size= 2048MB, count=1: write-back
reg01: base=0x07e700000 ( 2023MB), size=    1MB, count=1: uncachable
reg02: base=0x07e800000 ( 2024MB), size=    8MB, count=1: uncachable
reg03: base=0x07f000000 ( 2032MB), size=   16MB, count=1: uncachable
reg04: base=0x080000000 ( 2048MB), size=  256MB, count=2: write-combining
                                                      ^^^

-- 
	Paolo Ornati
	Linux 2.6.29-rc5-00206-g402a917 on x86_64
