Return-Path: <linux-kernel-owner+w=401wt.eu-S1762095AbYA3XoN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762095AbYA3XoN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 18:44:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754458AbYA3Xnq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 18:43:46 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:34355 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753492AbYA3Xno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 18:43:44 -0500
Date: Wed, 30 Jan 2008 15:50:17 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: Re: [PATCH] x86_64: make bootmap_start page align v5
In-reply-to: <200801301523.36785.yinghai.lu@sun.com>
To: Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>
Cc: Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Message-id: <200801301550.18513.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200801291113.35974.yinghai.lu@sun.com>
 <200801301215.51645.yinghai.lu@sun.com> <200801301523.36785.yinghai.lu@sun.com>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 January 2008 03:23:35 pm Yinghai Lu wrote:
> [PATCH] x86_64: make bootmap_start page align v5

Ingo,

Please consider to apply
v5:
or
v4:  http://lkml.org/lkml/2008/1/30/377
it makes bootmap page alignment
or
v2: http://lkml.org/lkml/2008/1/29/349
it makes NODE_DATA and bootmap page alignement

just pick one.

YH

v5:
Bootmem setup node 0 0000000000000000-0000000828000000
  NODE_DATA [000000000008b000 - 0000000000091fff]
  bootmap [0000000000d9d000 -  0000000000ea1fff] pages 105
Bootmem setup node 1 0000000828000000-0000001028000000
  NODE_DATA [0000000828000000 - 0000000828006fff]
  bootmap [0000000828007000 -  0000000828106fff] pages 100
Bootmem setup node 2 0000001028000000-0000001828000000
  NODE_DATA [0000001028000000 - 0000001028006fff]
  bootmap [0000001028007000 -  0000001028106fff] pages 100
Bootmem setup node 3 0000001828000000-0000002028000000
  NODE_DATA [0000001828000000 - 0000001828006fff]
  bootmap [0000001828007000 -  0000001828106fff] pages 100
early res: 0 [0-1000) BIOS data page
early res: 1 [6000-8000) SMP_TRAMPOLINE
early res: 2 [200000-d9c274) TEXT DATA BSS
early res: 3 [7e6f4000-7fff3a26) RAMDISK
early res: 4 [99800-9d800) EBDA
early res: 5 [8000-8a000) PGTABLE
early res: 6 [8a000-8a88b) MEMNODEMAP

v4:
Bootmem setup node 0 0000000000000000-0000000828000000
  NODE_DATA [000000000008a88b - 000000000009188a]
  bootmap [0000000000d9d000 -  0000000000ea1fff] pages 105
Bootmem setup node 1 0000000828000000-0000001028000000
  NODE_DATA [0000000828000000 - 0000000828006fff]
  bootmap [0000000828007000 -  0000000828106fff] pages 100
Bootmem setup node 2 0000001028000000-0000001828000000
  NODE_DATA [0000001028000000 - 0000001028006fff]
  bootmap [0000001028007000 -  0000001028106fff] pages 100
Bootmem setup node 3 0000001828000000-0000002028000000
  NODE_DATA [0000001828000000 - 0000001828006fff]
  bootmap [0000001828007000 -  0000001828106fff] pages 100
early res: 0 [0-1000) BIOS data page
early res: 1 [6000-8000) SMP_TRAMPOLINE
early res: 2 [200000-d9c274) TEXT DATA BSS
early res: 3 [7e6f4000-7fff3a26) RAMDISK
early res: 4 [99800-9d800) EBDA
early res: 5 [8000-8a000) PGTABLE
early res: 6 [8a000-8a88b) MEMNODEMAP

v2:
Bootmem setup node 0 0000000000000000-0000000828000000
  NODE_DATA [000000000008b000 - 0000000000091fff]
  bootmap [0000000000d9d000 -  0000000000ea1fff] pages 105
Bootmem setup node 1 0000000828000000-0000001028000000
  NODE_DATA [0000000828000000 - 0000000828006fff]
  bootmap [0000000828007000 -  0000000828106fff] pages 100
Bootmem setup node 2 0000001028000000-0000001828000000
  NODE_DATA [0000001028000000 - 0000001028006fff]
  bootmap [0000001028007000 -  0000001028106fff] pages 100
Bootmem setup node 3 0000001828000000-0000002028000000
  NODE_DATA [0000001828000000 - 0000001828006fff]
  bootmap [0000001828007000 -  0000001828106fff] pages 100
early res: 0 [0-1000) BIOS data page
early res: 1 [6000-8000) SMP_TRAMPOLINE
early res: 2 [200000-d9c274) TEXT DATA BSS
early res: 3 [7e6f4000-7fff3a26) RAMDISK
early res: 4 [99800-9d800) EBDA
early res: 5 [8000-8a000) PGTABLE
early res: 6 [8a000-8a88b) MEMNODEMAP


