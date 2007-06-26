Return-Path: <linux-kernel-owner+w=401wt.eu-S1756668AbXFZFVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668AbXFZFVc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 01:21:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753191AbXFZFVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 01:21:24 -0400
Received: from ns2.suse.de ([195.135.220.15]:53942 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751456AbXFZFVY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 01:21:24 -0400
From: Marcus Meissner <meissner@suse.de>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH try #3] security: Convert LSM into a static interface
In-Reply-To: <Line.LNX.4.64.0706251953020.25122@localhost.localdomain.suse.lists.linux.kernel>
X-Newsgroups: suse.lists.linux.kernel
User-Agent: tin/1.8.2-20060425 ("Shillay") (UNIX) (Linux/2.6.18.8-0.3-ppc64 (ppc64))
Message-Id: <20070626052122.9AA8630108@grape.suse.de>
Date: Tue, 26 Jun 2007 07:21:22 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In article <Line.LNX.4.64.0706251953020.25122@localhost.localdomain.suse.lists.linux.kernel> you wrote:
> Convert LSM into a static interface, as the ability to unload a security
> module is not required by in-tree users and potentially complicates the
> overall security architecture.
> 
> Needlessly exported LSM symbols have been unexported, to help reduce API
> abuse.
> 
> Parameters for the capability and root_plug modules are now specified
> at boot.
> 
> The SECURITY_FRAMEWORK_VERSION macro has also been removed.
> 
> Signed-off-by: James Morris <jmorris@namei.org>

NAK.

First, such an interface should be obsoleted by first making an entry
to Documentation/feature-removal-schedule.txt and waiting for some months.

Second, security modules that cannot be loaded/unloaded can just marked
so and the LSM interface kept as-is.

You are aware of the out of tree users, like AppArmor and other security
modules and there are also several antivirus modules like dazuko, mcafee
(got riddance for the latter, but in general) using LSM.

Ciao, Marcus
