Return-Path: <linux-kernel-owner+w=401wt.eu-S935313AbXFGBsE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935313AbXFGBsE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 21:48:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936396AbXFGBrm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 21:47:42 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:52825
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936368AbXFGBrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 21:47:41 -0400
From: Rob Landley <rob@landley.net>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH RFC 6/7] i386: make the bzImage payload an ELF file
Date: Wed, 6 Jun 2007 21:47:20 -0400
User-Agent: KMail/1.9.1
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Vivek Goyal <vgoyal@in.ibm.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Andi Kleen <ak@suse.de>,
       v12n <virtualization@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
References: <20070606225837.654272428@goop.org> <20070606230922.476662240@goop.org> <4667462A.2010404@zytor.com>
In-Reply-To: <4667462A.2010404@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706062147.21225.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06 June 2007 7:41 pm, H. Peter Anvin wrote:
> This makes vmlinux (normally stripped) recoverable from the bzImage file
> and so anything that is currently booting vmlinux would be serviced by
> this scheme.

Would this make it sane to strip the initramfs image out of vmlinux with 
objdump and replace it with another one, or are there offsets resolved during 
the build that stop that for vmlinux?

Rob
-- 
The Google cluster became self-aware at 2:14am EDT August 29, 2007...
