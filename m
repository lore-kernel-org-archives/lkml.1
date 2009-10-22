Return-Path: <linux-kernel-owner+w=401wt.eu-S1754111AbZJVHbL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111AbZJVHbL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 03:31:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752464AbZJVHbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 03:31:10 -0400
Received: from qmta01.emeryville.ca.mail.comcast.net ([76.96.30.16]:32992 "EHLO
	QMTA01.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751263AbZJVHbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 03:31:09 -0400
Subject: Re: [RFC][PATCH 1/2] binfmt_elf: FatELF support in the binary
 loader.
From: Nicholas Miell <nmiell@comcast.net>
To: "Ryan C. Gordon" <icculus@icculus.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.0910190418500.13303@andre.icculuslan>
References: <alpine.DEB.2.00.0910190418500.13303@andre.icculuslan>
Content-Type: text/plain
Date: Thu, 22 Oct 2009 00:31:12 -0700
Message-Id: <1256196672.15558.1.camel@entropy>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-19 at 10:39 -0400, Ryan C. Gordon wrote:
> This allows the kernel to load a single file that contains multiple ELF
> binaries (a "FatELF" file), selecting the correct one for the system.
> 
> Details, rationale, tools, and patches for handling FatELF binaries can be
> found at http://icculus.org/fatelf/
> 
> Please note that this requires userspace changes to be truly effective, 
> but a simple "hello world" FatELF binary can work with just the kernel 
> loader.

Apple's fat binaries have the virtue of allowing redundant identical
sections to be merged among the different included binaries, but your
format can't do that.

Could you explain how your FatELF format is an improvement over multiple
ELF binaries and a simple shell script that selects between them?

-- 
Nicholas Miell <nmiell@comcast.net>

