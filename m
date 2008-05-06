Return-Path: <linux-kernel-owner+w=401wt.eu-S1763308AbYEFSjB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763308AbYEFSjB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 14:39:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755040AbYEFSiY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 14:38:24 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:14011 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756015AbYEFSiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 14:38:03 -0400
Message-ID: <4820A588.3080902@de.ibm.com>
Date: Tue, 06 May 2008 20:38:00 +0200
From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@medozas.de>
CC: ltp-list@lists.sourceforge.net, Andrew Morton <akpm@linux-foundation.org>,
       ltp-coverage@lists.sourceforge.net, sam@ravnborg.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/6] kbuild: let addtree result in absolute paths
 only
References: <481F26A0.5010402@de.ibm.com> <alpine.LNX.1.10.0805060936250.11757@fbirervta.pbzchgretzou.qr>
In-Reply-To: <alpine.LNX.1.10.0805060936250.11757@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Monday 2008-05-05 17:24, Peter Oberparleiter wrote:
>>+++ linux-2.6.26-rc1/scripts/Kbuild.include
>>@@ -144,7 +144,7 @@ ld-option = $(call try-run,\
>> build := -f $(if $(KBUILD_SRC),$(srctree)/)scripts/Makefile.build obj
>> 
>> # Prefix -I with $(srctree) if it is not an absolute path.
>>-addtree = $(if $(filter-out -I/%,$(1)),$(patsubst -I%,-I$(srctree)/%,$(1))) $(1)
>>+addtree = $(if $(filter-out -I/%,$(1)),$(patsubst -I%,-I$(srctree)/%,$(1)),$(1))
> 
> At least make it so that relative can be used whenever possible (e.g. on 
> !CONFIG_GCOV)

Good idea - I'll consider it for the next patch version.


Regards,
  Peter
