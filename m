Return-Path: <linux-kernel-owner+w=401wt.eu-S1754659AbZBUSPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659AbZBUSPA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 13:15:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752513AbZBUSOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 13:14:51 -0500
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:49835 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363AbZBUSOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 13:14:51 -0500
Date: Sat, 21 Feb 2009 18:14:49 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Paolo Ornati <ornati@fastwebnet.it>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Eric Anholt <eric@anholt.net>, Dave Airlie <airlied@linux.ie>
Subject: Re: [BISECTED] [drm:i915_initialize] *ERROR* can not ioremap virtual address for ring buffer
Message-ID: <20090221181449.GA13180@silver.sucs.org>
References: <20090221110011.030cb16d@fastwebnet.it> <20090221121944.GA21090@silver.sucs.org> <20090221134933.368c2709@fastwebnet.it> <20090221135233.58fbae0b@fastwebnet.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090221135233.58fbae0b@fastwebnet.it>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 21, 2009 at 01:52:33PM +0100, Paolo Ornati wrote:
> On Sat, 21 Feb 2009 13:49:33 +0100
> Paolo Ornati <ornati@fastwebnet.it> wrote:
> 
> $ cat /proc/mtrr
> reg00: base=0x000000000 (    0MB), size= 2048MB, count=1: write-back
> reg01: base=0x07e700000 ( 2023MB), size=    1MB, count=1: uncachable
> reg02: base=0x07e800000 ( 2024MB), size=    8MB, count=1: uncachable
> reg03: base=0x07f000000 ( 2032MB), size=   16MB, count=1: uncachable
> reg04: base=0x080000000 ( 2048MB), size=  256MB, count=2: write-combining
>                                                       ^^^

Regarding the increase in count - are you sure that wasn't happening due
to X (i.e. before X starts the count is 1 and after X has set things up
the count goes to 2)?

-- 
Sitsofe | http://sucs.org/~sits/
