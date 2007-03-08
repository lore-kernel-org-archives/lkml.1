Return-Path: <linux-kernel-owner+w=401wt.eu-S1030641AbXCHVpF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030641AbXCHVpF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 16:45:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030671AbXCHVpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 16:45:05 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:48037 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030641AbXCHVpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 16:45:01 -0500
Subject: Re: [RFC][Patch 1/6] integrity: new hooks
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Valdis.Kletnieks@vt.edu
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
       Casey Schaufler <casey@schaufler-ca.com>, linux-kernel@vger.kernel.org,
       safford@watson.ibm.com, serue@linux.vnet.ibm.com,
       kjhall@linux.vnet.ibm.com, zohar@us.ibm.com
In-Reply-To: <200703082038.l28Kcowq023278@turing-police.cc.vt.edu>
References: <20070308170001.GA17304@sergelap.austin.ibm.com>
	 <33939.11500.qm@web36612.mail.mud.yahoo.com>
	 <20070308184646.GC21099@sergelap.austin.ibm.com>
	 <200703082038.l28Kcowq023278@turing-police.cc.vt.edu>
Content-Type: text/plain
Date: Thu, 08 Mar 2007 16:57:24 -0500
Message-Id: <1173391044.5981.11.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-08 at 15:38 -0500, Valdis.Kletnieks@vt.edu wrote:
> On Thu, 08 Mar 2007 12:46:47 CST, "Serge E. Hallyn" said:
> > I think it should be done as both.  The part which measures the
> > integrity of files should be an integrity subsystem.  The part which
> > uses those results to either allow/refuse actions or take some other
> > action (i.e. shut down the system) should be an lsm.
> 
> That would be good - the allow/deny parts, being security, can use the
> existing LSM hooks, and the integrity part can use the LIM hooks.
> 
> Umm... wait a minute - *what* Linux Integrity Module hooks? :)

Hm, integrity-service-api-and-dummy-provider.patch contains:
integrity_verify_metadata, integrity_verify_data, and integrity_measure,
which could be referred to as either LIM hooks or as the API. This patch 
set adds 8 new LIM hooks.

Mimi Zohar

