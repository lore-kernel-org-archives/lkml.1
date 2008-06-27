Return-Path: <linux-kernel-owner+w=401wt.eu-S1758644AbYF0AMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758644AbYF0AMV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 20:12:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752392AbYF0AML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 20:12:11 -0400
Received: from hu-out-0506.google.com ([72.14.214.233]:59176 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715AbYF0AMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 20:12:09 -0400
Message-ID: <1d3f23370806261712s5251253cs5f9c8d6614184bae@mail.gmail.com>
Date: Fri, 27 Jun 2008 10:12:07 +1000
From: "John Williams" <john.williams@petalogix.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: Microblaze init port v4
Cc: monstr@seznam.cz, linux-kernel@vger.kernel.org, arnd@arndb.de,
       linux-arch@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       John.Linn@xilinx.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, linuxppc-dev@ozlabs.org,
       vapier.adi@gmail.com, alan@lxorguk.ukuu.org.uk, hpa@zytor.com
In-Reply-To: <20080626150121.GB22025@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1214483429-32360-1-git-send-email-monstr@seznam.cz>
	 <20080626150121.GB22025@cs181140183.pp.htv.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 6/27/08, Adrian Bunk <bunk@kernel.org> wrote:
> On Thu, Jun 26, 2008 at 02:29:29PM +0200, monstr@seznam.cz wrote:

>  > current linux version is 2.6.26-rc8 and I think this is the right time
>  > to send latest patches againts rc8 for Microblaze CPU.
>  >...
>
>  Thanks for your work on getting the architecture included.
>
>  I have two questions:
>
>  Where can I find a toolchain for compiling a Microblaze kernel?

We bundle it in the PetaLinux distro:

http://developer.petalogix.com

>  What is the status of Microblaze support in upstream binutils and gcc?

noMMU uClibc toolchain is at 3.4.1, MMU/glibc is at 4.1.1  Xilinx does
their gcc/binutils stuff mostly in-house, and none of it is upstream.
We (PetaLogix) build and distribute the uClibc toolchain, and we are
slowly merging the MMU support across to our regular distro, that will
also include the glibc tools.

Cheers,

John
-- 
John Williams, PhD, B.Eng, B.IT
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com  p: +61-7-30090663  f: +61-7-30090663
