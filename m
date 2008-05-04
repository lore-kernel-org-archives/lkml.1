Return-Path: <linux-kernel-owner+w=401wt.eu-S1757971AbYEDTlm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757971AbYEDTlm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 15:41:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755413AbYEDTlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 15:41:35 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:65227 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755327AbYEDTle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 15:41:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=WOeYHzOMZDL7t4QM31YPtzxe4UN3oD6AVtO4jQVbxeqt55y/XEnGGzwZ7vt/bLJxtElXkGOFVWJ5Su4ZFUf3OXTlBVMmWukWzmPfLWRYc8faeAAKCDj4MRhhtdPTnos/wVSncEcj51d6GgzORRxAwxqO6YaCJ8yK/61oVmoJefU=
Message-ID: <2da21fe50805041241k4b79ef87j689cbe9d93d6d1d4@mail.gmail.com>
Date: Sun, 4 May 2008 21:41:33 +0200
From: "Davide Pesavento" <davidepesa@gmail.com>
To: "Sam Ravnborg" <sam@ravnborg.org>
Subject: Re: linux-2.6.26-rc1 - section mismatches on x86
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/4/11 Sam Ravnborg <sam@ravnborg.org>:
> On Fri, Apr 11, 2008 at 08:02:06PM +0200, Davide Pesavento wrote:
>  > While compiling linux-2.6.25-rc8-git7 with
>  > CONFIG_DEBUG_SECTION_MISMATCH=y, I noticed the following "section
>  > mismatch" warnings.
>
>  Thanks for your report Davide.
>  We have several "Section mismatch warning" fixes queued
>  up in -mm and in x86.git so I expect most of the ones below
>  to be already fixed.
>  Merging is postponed until next merge window.
>
>  A similar report at -rc1 time would be good.
>
>         Sam
>

Hello again!

I tried 2.6.26-rc1 and only these two warnings are left:

WARNING: vmlinux.o(.text+0x10fe7): Section mismatch in reference from
the function cpu_exit_clear() to the function
.cpuinit.text:cpu_uninit()
The function cpu_exit_clear() references
the function __cpuinit cpu_uninit().
This is often because cpu_exit_clear lacks a __cpuinit
annotation or the annotation of cpu_uninit is wrong.

WARNING: vmlinux.o(.text+0x1e26e4): Section mismatch in reference from
the function pci_scan_bus_on_node() to the function
.devinit.text:pci_scan_bus_parented()
The function pci_scan_bus_on_node() references
the function __devinit pci_scan_bus_parented().
This is often because pci_scan_bus_on_node lacks a __devinit
annotation or the annotation of pci_scan_bus_parented is wrong.
