Return-Path: <linux-kernel-owner+w=401wt.eu-S1758345AbXJKTMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758345AbXJKTMV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 15:12:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755235AbXJKTMO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 15:12:14 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:38778 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754469AbXJKTMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 15:12:13 -0400
Date: Thu, 11 Oct 2007 21:12:12 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: "Agarwal, Lomesh" <lomesh.agarwal@intel.com>, Valdis.Kletnieks@vt.edu,
       linux-kernel@vger.kernel.org
Subject: Re: TPM driver changes to support multiple locality
In-Reply-To: <20071011115429.92326cbd.randy.dunlap@oracle.com>
Message-ID: <Pine.LNX.4.64.0710112110360.32234@fbirervta.pbzchgretzou.qr>
References: <A3258B497F1C1441AD36A2E8B45FD628C7D657@scsmsx412.amr.corp.intel.com>
 <27383.1192045583@turing-police.cc.vt.edu>
 <A3258B497F1C1441AD36A2E8B45FD628CB9AEE@scsmsx412.amr.corp.intel.com>
 <20071011115429.92326cbd.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 11 2007 11:54, Randy Dunlap wrote:
>On Thu, 11 Oct 2007 11:33:35 -0700 Agarwal, Lomesh wrote:
>
>> Below is the patch for TPM driver.
>> Comments/suggestions?
>
>Observe/use kernel coding style.
>Run the patch thru scripts/checkpatch.pl and check its suggestions.
>Use "diffstat -p1 -w70" and put that summary near the top of the
>patch (after the patch description).

Or, if using quilt on top of the tree, a simple `quilt diff
--diffstat --sort` will do all the nice diffing, including stat and
use diff -pu. It also preserves diffstat (if not regenerating that)
and patch description, so is suited *perfectly* for the task when you
don't want to use stgit.
