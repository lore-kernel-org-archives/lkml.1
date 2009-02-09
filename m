Return-Path: <linux-kernel-owner+w=401wt.eu-S1755217AbZBIKdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217AbZBIKdZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 05:33:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753181AbZBIKdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 05:33:10 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:52953 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754840AbZBIKdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 05:33:08 -0500
Date: Mon, 9 Feb 2009 10:32:05 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Sami Farin <safari-kernel@safari.iki.fi>
Subject: Re: [Bug #12669] 2.6.28.4 regression: mmap fails if mlockall used
In-Reply-To: <sWhNs83kKPE.A.jpD.H20jJB@chimera>
Message-ID: <Pine.LNX.4.64.0902091028390.14410@blonde.anvils>
References: <AIghyjFgMFP.A.uZD._10jJB@chimera> <sWhNs83kKPE.A.jpD.H20jJB@chimera>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Feb 2009, Rafael J. Wysocki wrote:
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12669
> Subject		: 2.6.28.4 regression: mmap fails if mlockall used
> Submitter	: Sami Farin <safari-kernel@safari.iki.fi>
> Date		: 2009-02-08 10:52 (1 days old)
> References	: http://marc.info/?l=linux-kernel&m=123409037423068&w=4

Please still list it for now, but I expect
d5b562330ec766292a3ac54ae5e0673610bd5b3d
mm: fix error case in mlock downgrade reversion
(which went in just after -rc4) to have fixed it:
let's wait for confirmation from Sami before removing.

Hugh
