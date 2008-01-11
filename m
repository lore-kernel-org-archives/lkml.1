Return-Path: <linux-kernel-owner+w=401wt.eu-S1760737AbYAKKLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760737AbYAKKLT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 05:11:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757560AbYAKKLM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 05:11:12 -0500
Received: from ns.firmix.at ([62.141.48.66]:4527 "EHLO ns.firmix.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755157AbYAKKLL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 05:11:11 -0500
Subject: Re: [PATCH] checkpatch.pl: allow piping
From: Bernd Petrovitsch <bernd@firmix.at>
To: Daniel Walker <dwalker@mvista.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, apw@shadowen.org,
       linux-kernel@vger.kernel.org, rdunlap@xenotime.net,
       jschopp@austin.ibm.com
In-Reply-To: <1200044878.29897.78.camel@imap.mvista.com>
References: <20080111041120.085610726@mvista.com>
	 <47872E35.3070705@gmail.com> <1200043035.29897.62.camel@imap.mvista.com>
	 <47873505.7040008@gmail.com>  <1200043399.3905.9.camel@gimli.at.home>
	 <1200043827.29897.70.camel@imap.mvista.com>  <47873833.30001@gmail.com>
	 <1200044206.29897.73.camel@imap.mvista.com>  <478739AD.3000005@gmail.com>
	 <1200044878.29897.78.camel@imap.mvista.com>
Content-Type: text/plain
Organization: Firmix Software GmbH
Date: Fri, 11 Jan 2008 11:11:03 +0100
Message-Id: <1200046263.10166.9.camel@tara.firmix.at>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
X-Firmix-Scanned-By: MIMEDefang 2.56 on ns.firmix.at
X-Firmix-Spam-Score: -2.334 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Spam-Status: No, hits=-2.334 required=5
X-Spam-Score: -2.334 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Envelope-From: <bernd@firmix.at>
X-Firmix-Envelope-To: <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fre, 2008-01-11 at 01:47 -0800, Daniel Walker wrote:
> On Fri, 2008-01-11 at 10:41 +0100, Jiri Slaby wrote:
> > On 01/11/2008 10:36 AM, Daniel Walker wrote:
> > > On Fri, 2008-01-11 at 10:34 +0100, Jiri Slaby wrote:
> > >> If somebody is hacking kernel, I think he should know the - trick used in many 
> > >> programs, but do not consider this as a nack.
> > > 
> > > I'm hacking the kernel, and I didn't know the - trick .. So you have
> > > your testing case all in one with the patch submitter ..
> > 
> > OK, maybe we should base it in doc for patch submitting then?
> 
> It's in the bash docs I'm sure, it's just a matter of who ends up

Yes, too. And "awk" also supports that.
But "/dev/stdin" is also since ages a symlink to
"/proc/self/fd/0" (which is another equivalent "file").

> reading that part of the docs.. I still think my patch is a good one ,
> we could change the name to "Allow piping with out tricks" I suppose ..

	Bernd
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services


