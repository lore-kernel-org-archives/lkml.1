Return-Path: <linux-kernel-owner+w=401wt.eu-S1757148AbZEBOO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757148AbZEBOO7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 10:14:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754215AbZEBOOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 10:14:51 -0400
Received: from hiauly1.hia.nrc.ca ([132.246.100.193]:4493 "EHLO
	hiauly1.hia.nrc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754199AbZEBOOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 10:14:50 -0400
X-Greylist: delayed 647 seconds by postgrey-1.27 at vger.kernel.org; Sat, 02 May 2009 10:14:50 EDT
Subject: Re: [PATCH 3/5] parisc: use new macros for .data.init_task.
To: deller@gmx.de (Helge Deller)
Date: Sat, 2 May 2009 10:04:01 -0400 (EDT)
From: "John David Anglin" <dave@hiauly1.hia.nrc.ca>
Cc: tabbott@MIT.EDU, sam@ravnborg.org, linux-kernel@vger.kernel.org,
       andersk@MIT.EDU, wdaher@MIT.EDU, vda.linux@googlemail.com,
       jbarnold@MIT.EDU, kyle@mcmartin.ca, linux-parisc@vger.kernel.org
In-Reply-To: <49FBD681.9080605@gmx.de> from "Helge Deller" at May 2, 2009 07:13:37 am
X-Mailer: ELM [version 2.4 PL25]
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Message-Id: <20090502140402.AC1124FC6@hiauly1.hia.nrc.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> IIRC, gcc on hppa is not able to provide an alignment >= 8k, which is
> why we have done the 16k alignment inside the linker script.

How does this arise?  We have the following define for MAX_OFILE_ALIGNMENT
in elfos.h:

#define MAX_OFILE_ALIGNMENT (((unsigned int) 1 << 28) * 8)

If you are correct, MAX_OFILE_ALIGNMENT should be changed.

Dave
-- 
J. David Anglin                                  dave.anglin@nrc-cnrc.gc.ca
National Research Council of Canada              (613) 990-0752 (FAX: 952-6602)
