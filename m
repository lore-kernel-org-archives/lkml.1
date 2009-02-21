Return-Path: <linux-kernel-owner+w=401wt.eu-S1755207AbZBUT2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207AbZBUT2T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 14:28:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753876AbZBUT2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 14:28:11 -0500
Received: from aa012msr.fastwebnet.it ([85.18.95.72]:57938 "EHLO
	aa012msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842AbZBUT2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 14:28:10 -0500
Date: Sat, 21 Feb 2009 20:28:07 +0100
From: Paolo Ornati <ornati@fastwebnet.it>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Eric Anholt <eric@anholt.net>, Dave Airlie <airlied@linux.ie>
Subject: Re: [BISECTED] [drm:i915_initialize] *ERROR* can not ioremap
 virtual address for ring buffer
Message-ID: <20090221202807.7ede148c@fastwebnet.it>
In-Reply-To: <20090221181449.GA13180@silver.sucs.org>
References: <20090221110011.030cb16d@fastwebnet.it>
	<20090221121944.GA21090@silver.sucs.org>
	<20090221134933.368c2709@fastwebnet.it>
	<20090221135233.58fbae0b@fastwebnet.it>
	<20090221181449.GA13180@silver.sucs.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Feb 2009 18:14:49 +0000
Sitsofe Wheeler <sitsofe@yahoo.com> wrote:

> > $ cat /proc/mtrr
> > reg00: base=0x000000000 (    0MB), size= 2048MB, count=1: write-back
> > reg01: base=0x07e700000 ( 2023MB), size=    1MB, count=1: uncachable
> > reg02: base=0x07e800000 ( 2024MB), size=    8MB, count=1: uncachable
> > reg03: base=0x07f000000 ( 2032MB), size=   16MB, count=1: uncachable
> > reg04: base=0x080000000 ( 2048MB), size=  256MB, count=2: write-combining
> >                                                       ^^^  
> 
> Regarding the increase in count - are you sure that wasn't happening due
> to X (i.e. before X starts the count is 1 and after X has set things up
> the count goes to 2)?

Ah, yes, you are right  ;)

-- 
	Paolo Ornati
	Linux 2.6.29-rc5-00206-g402a917 on x86_64
